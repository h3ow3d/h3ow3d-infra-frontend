# Custom Domain Example
# Shows how to add a custom domain to your frontend

terraform {
  required_version = ">= 1.14.1"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.0"
    }
  }
}

provider "aws" {
  region = "eu-west-2"
}

# Provider for ACM certificate (CloudFront requires us-east-1)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

# Get existing Route53 hosted zone
data "aws_route53_zone" "main" {
  name         = "example.com"
  private_zone = false
}

module "frontend" {
  source = "../.."

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project_name = "my-app"
  environment  = "production"

  # Custom domain configuration
  domain_name    = "app.example.com"
  hosted_zone_id = data.aws_route53_zone.main.zone_id

  tags = {
    Example = "custom-domain"
  }
}

# Outputs
output "website_url" {
  description = "Custom domain URL"
  value       = module.frontend.website_url
}

output "certificate_arn" {
  description = "ACM certificate ARN (auto-created)"
  value       = module.frontend.certificate_arn
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for deployment"
  value       = module.frontend.cloudfront_distribution_id
}

output "s3_bucket_name" {
  description = "S3 bucket for website files"
  value       = module.frontend.s3_bucket_name
}
