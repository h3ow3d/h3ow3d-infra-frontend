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

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudfront_distribution.cdn](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudfront_distribution) | resource |
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
| <a name="input_acm_certificate_arn"></a> [acm\_certificate\_arn](#input\_acm\_certificate\_arn) | Optional ACM certificate ARN for CloudFront | `string` | `null` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_project_name"></a> [project\_name](#input\_project\_name) | Project name used for resource naming | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_artifacts_bucket_name"></a> [artifacts\_bucket\_name](#output\_artifacts\_bucket\_name) | Artifacts S3 bucket name |
| <a name="output_cloudfront_distribution_id"></a> [cloudfront\_distribution\_id](#output\_cloudfront\_distribution\_id) | CloudFront distribution ID |
| <a name="output_cloudfront_domain_name"></a> [cloudfront\_domain\_name](#output\_cloudfront\_domain\_name) | CloudFront distribution domain name |
| <a name="output_s3_bucket_name"></a> [s3\_bucket\_name](#output\_s3\_bucket\_name) | Name of the S3 bucket for the frontend |
<!-- END_TF_DOCS -->
