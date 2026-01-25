# Frontend Module

Creates an S3-hosted static website, CloudFront distribution, and an artifacts bucket for build artifacts. Optionally supports custom domains with automatic ACM certificate creation and Route53 DNS configuration.

## Features

- S3 bucket for static website hosting
- CloudFront CDN with optimized caching
- S3 artifacts bucket for build storage
- Optional custom domain with automatic ACM certificate
- Optional Route53 DNS configuration
- Configurable CloudFront price class

## Examples

- [**Basic**](./examples/basic) - Simple S3 + CloudFront hosting with default domain
- [**Custom Domain**](./examples/custom-domain) - Add a custom domain with automatic ACM certificate
- [**Complete**](./examples/complete) - All features with custom configuration

## Quick Start

### Without Custom Domain

```hcl
module "frontend" {
  source = "git::https://github.com/h3ow3d/h3ow3d-infra.git//modules/h3ow3d-infra-frontend?ref=v1.0.0"

  project_name = "my-app"
  environment  = "production"
}
```

### With Custom Domain

```hcl
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "frontend" {
  source = "git::https://github.com/h3ow3d/h3ow3d-infra.git//modules/h3ow3d-infra-frontend?ref=v1.0.0"

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project_name   = "my-app"
  environment    = "production"
  domain_name    = "app.example.com"
  hosted_zone_id = "Z1234567890ABC"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.14.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5.0 |
| <a name="provider_aws.us_east_1"></a> [aws.us\_east\_1](#provider\_aws.us\_east\_1) | >= 5.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/acm_certificate_validation) | resource |
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
| [aws_route53_record.cert_validation](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_route53_record.domain](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route53_record) | resource |
| [aws_s3_bucket.artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_lifecycle_configuration.artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_lifecycle_configuration) | resource |
| [aws_s3_bucket_policy.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_versioning.artifacts](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_website_configuration.site](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_website_configuration) | resource |
| [aws_iam_policy_document.public_read](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | Optional ACM certificate ARN for CloudFront (if not provided, will be created automatically when domain\_name is set) | `string` | `null` | no |
| <a name="input_additional_cache_behaviors"></a> [additional\_cache\_behaviors](#input\_additional\_cache\_behaviors) | Additional CloudFront cache behaviors | <pre>list(object({<br>    path_pattern             = string<br>    target_origin_id         = string<br>    viewer_protocol_policy   = optional(string, "redirect-to-https")<br>    allowed_methods          = optional(list(string), ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])<br>    cached_methods           = optional(list(string), ["GET", "HEAD"])<br>    compress                 = optional(bool, true)<br>    cache_policy_id          = optional(string)<br>    origin_request_policy_id = optional(string)<br>  }))</pre> | `[]` | no |
| <a name="input_additional_origins"></a> [additional\_origins](#input\_additional\_origins) | Additional CloudFront origins (e.g., for Lambda Function URLs or APIs) | <pre>list(object({<br>    origin_id   = string<br>    domain_name = string<br>    origin_path = optional(string, "")<br>    custom_header = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>  }))</pre> | `[]` | no |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | Optional custom domain name for CloudFront (e.g., app.example.com) | `string` | `""` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_hosted_zone_id"></a> [hosted\_zone\_id](#input\_hosted\_zone\_id) | Route53 hosted zone ID (required if domain\_name is set) | `string` | `""` | no |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for resource naming | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifacts_bucket_name"></a> [artifacts\_bucket\_name](#output\_artifacts\_bucket\_name) | Artifacts S3 bucket name |
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | ARN of the ACM certificate (if custom domain is used) |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | CloudFront distribution ID |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | CloudFront distribution domain name |
| <a name="output_cloudfront_hosted_zone_id"></a> [cloudfront\_hosted\_zone\_id](#output\_cloudfront\_hosted\_zone\_id) | CloudFront distribution hosted zone ID |
| <a name="output_domain_name"></a> [domain\_name](#output\_domain\_name) | Custom domain name (if configured) |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of the S3 bucket for the frontend |
| <a name="output_website_url"></a> [website\_url](#output\_website\_url) | URL to access the website |
<!-- END_TF_DOCS -->
