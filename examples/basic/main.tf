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
  environment  = "dev"

  tags = {
    Example = "basic"
  }
}

output "example_output" {
  description = "Example output from module"
  value       = module.example
}
