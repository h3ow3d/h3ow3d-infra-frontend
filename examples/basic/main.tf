# Basic Example - Frontend hosting without custom domain
# Uses CloudFront default domain name

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

# Provider for ACM certificate (required by module even if not using custom domain)
provider "aws" {
  alias  = "us_east_1"
  region = "us-east-1"
}

module "frontend" {
  source = "../.."

  providers = {
    aws.us_east_1 = aws.us_east_1
  }

  project_name = "my-app"
  environment  = "dev"

  tags = {
    Example = "basic"
  }
}

output "s3_bucket_name" {
  description = "S3 bucket for website files"
  value       = module.frontend.s3_bucket_name
}

output "cloudfront_distribution_id" {
  description = "CloudFront distribution ID for deployment"
  value       = module.frontend.cloudfront_distribution_id
}

output "website_url" {
  description = "Website URL"
  value       = module.frontend.website_url
}

output "artifacts_bucket_name" {
  description = "Artifacts bucket for build storage"
  value       = module.frontend.artifacts_bucket_name
}
