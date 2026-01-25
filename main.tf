locals {
  bucket_name = "${var.project_name}-${var.environment}-site"

  # Determine certificate ARN: use provided one, or create new one if domain is specified
  use_custom_domain   = var.domain_name != ""
  certificate_arn     = var.acm_certificate_arn != null ? var.acm_certificate_arn : (local.use_custom_domain ? aws_acm_certificate.domain[0].arn : null)
  wait_for_validation = local.use_custom_domain && var.acm_certificate_arn == null
}

# ACM Certificate for custom domain (created in us-east-1 for CloudFront)
resource "aws_acm_certificate" "domain" {
  count             = local.use_custom_domain && var.acm_certificate_arn == null ? 1 : 0
  provider          = aws.us_east_1
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(var.tags, {
    Name = var.domain_name
  })
}

# DNS validation records for ACM certificate
resource "aws_route53_record" "cert_validation" {
  for_each = local.use_custom_domain && var.acm_certificate_arn == null ? {
    for dvo in aws_acm_certificate.domain[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  } : {}

  zone_id = var.hosted_zone_id
  name    = each.value.name
  type    = each.value.type
  records = [each.value.record]
  ttl     = 60
}

# Wait for certificate validation
resource "aws_acm_certificate_validation" "domain" {
  count                   = local.wait_for_validation ? 1 : 0
  provider                = aws.us_east_1
  certificate_arn         = aws_acm_certificate.domain[0].arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation : record.fqdn]
}

# S3 bucket for static website hosting
resource "aws_s3_bucket" "site" {
  bucket        = local.bucket_name
  force_destroy = true

  tags = merge(var.tags, {
    Name = local.bucket_name
  })
}

resource "aws_s3_bucket_public_access_block" "site" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = true
  block_public_policy     = false
  ignore_public_acls      = true
  restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "site" {
  bucket = aws_s3_bucket.site.id

  index_document { suffix = "index.html" }
  error_document { key = "index.html" }
}

data "aws_iam_policy_document" "public_read" {
  statement {
    sid     = "PublicReadGetObject"
    actions = ["s3:GetObject"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    resources = [
      "${aws_s3_bucket.site.arn}/*"
    ]
  }
}

resource "aws_s3_bucket_policy" "site" {
  bucket = aws_s3_bucket.site.id
  policy = data.aws_iam_policy_document.public_read.json
}

# CloudFront distribution (optional custom domain)
resource "aws_cloudfront_distribution" "cdn" {
  enabled = true
  aliases = local.use_custom_domain ? [var.domain_name] : []

  origin {
    domain_name = aws_s3_bucket_website_configuration.site.website_endpoint
    origin_id   = "s3-website-${aws_s3_bucket.site.id}"

    custom_origin_config {
      origin_protocol_policy = "http-only"
      http_port              = 80
      https_port             = 443
      origin_ssl_protocols   = ["TLSv1.2"]
    }
  }

  # Additional origins (e.g., Lambda Function URLs)
  dynamic "origin" {
    for_each = var.additional_origins
    content {
      domain_name = origin.value.domain_name
      origin_id   = origin.value.origin_id
      origin_path = origin.value.origin_path

      custom_origin_config {
        origin_protocol_policy = "https-only"
        http_port              = 80
        https_port             = 443
        origin_ssl_protocols   = ["TLSv1.2"]
      }

      dynamic "custom_header" {
        for_each = origin.value.custom_header
        content {
          name  = custom_header.value.name
          value = custom_header.value.value
        }
      }
    }
  }

  # Additional cache behaviors (must come before default)
  dynamic "ordered_cache_behavior" {
    for_each = var.additional_cache_behaviors
    content {
      path_pattern             = ordered_cache_behavior.value.path_pattern
      target_origin_id         = ordered_cache_behavior.value.target_origin_id
      viewer_protocol_policy   = ordered_cache_behavior.value.viewer_protocol_policy
      allowed_methods          = ordered_cache_behavior.value.allowed_methods
      cached_methods           = ordered_cache_behavior.value.cached_methods
      compress                 = ordered_cache_behavior.value.compress
      cache_policy_id          = ordered_cache_behavior.value.cache_policy_id
      origin_request_policy_id = ordered_cache_behavior.value.origin_request_policy_id
    }
  }

  default_cache_behavior {
    target_origin_id       = "s3-website-${aws_s3_bucket.site.id}"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]

    forwarded_values {
      query_string = true
      cookies {
        forward = "none"
      }
    }
    min_ttl     = 0
    default_ttl = 3600
    max_ttl     = 86400
  }

  price_class = "PriceClass_100"

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn            = local.certificate_arn
    cloudfront_default_certificate = local.certificate_arn == null ? true : false
    ssl_support_method             = local.certificate_arn != null ? "sni-only" : null
    minimum_protocol_version       = local.certificate_arn != null ? "TLSv1.2_2021" : null
  }

  default_root_object = "index.html"

  custom_error_response {
    error_code            = 404
    response_code         = 200
    response_page_path    = "/index.html"
    error_caching_min_ttl = 10
  }

  tags = merge(var.tags, { Name = "${var.project_name}-${var.environment}-cdn" })
}

# Route53 A record for custom domain
resource "aws_route53_record" "domain" {
  count   = local.use_custom_domain ? 1 : 0
  zone_id = var.hosted_zone_id
  name    = var.domain_name
  type    = "A"

  alias {
    name                   = aws_cloudfront_distribution.cdn.domain_name
    zone_id                = aws_cloudfront_distribution.cdn.hosted_zone_id
    evaluate_target_health = false
  }
}

# Artifacts bucket
resource "aws_s3_bucket" "artifacts" {
  bucket = "${var.project_name}-artifacts-${var.environment}"

  tags = merge(var.tags, {
    Name        = "${var.project_name}-${var.environment}-artifacts"
    Description = "Storage for build artifacts and releases"
  })
}

resource "aws_s3_bucket_versioning" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "artifacts" {
  bucket = aws_s3_bucket.artifacts.id

  rule {
    id     = "cleanup-old-builds"
    status = "Enabled"

    filter {
      prefix = "builds/"
    }

    noncurrent_version_expiration {
      noncurrent_days = 90
    }

    expiration {
      days = 365
    }
  }

  rule {
    id     = "keep-deployed-versions"
    status = "Enabled"

    filter {
      prefix = "deployed/"
    }

    expiration {
      days = 1825
    }
  }
}
