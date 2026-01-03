output "s3_bucket_name" {
  description = "Name of the S3 bucket for the frontend"
  value       = aws_s3_bucket.site.id
}

output "cloudfront_domain_name" {
  description = "CloudFront distribution domain name"
  value       = aws_cloudfront_distribution.cdn.domain_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID"
  value       = aws_cloudfront_distribution.cdn.id
}

output "cloudfront_hosted_zone_id" {
  description = "CloudFront distribution hosted zone ID"
  value       = aws_cloudfront_distribution.cdn.hosted_zone_id
}

output "artifacts_bucket_name" {
  description = "Artifacts S3 bucket name"
  value       = aws_s3_bucket.artifacts.id
}

output "certificate_arn" {
  description = "ARN of the ACM certificate (if custom domain is used)"
  value       = local.certificate_arn
}

output "domain_name" {
  description = "Custom domain name (if configured)"
  value       = local.use_custom_domain ? var.domain_name : null
}

output "website_url" {
  description = "URL to access the website"
  value       = local.use_custom_domain ? "https://${var.domain_name}" : "https://${aws_cloudfront_distribution.cdn.domain_name}"
}
