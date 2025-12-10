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

module "example" {
  source = "../.."

  project_name = "example"
  environment  = "production"

  # Add all module variables with example values

  tags = {
    Example   = "complete"
    ManagedBy = "terraform"
  }
}

output "all_outputs" {
  description = "All outputs from the module"
  value       = module.example
}
