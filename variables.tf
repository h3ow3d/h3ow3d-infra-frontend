variable "project_name" {
  description = "Project name used for resource naming"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "domain_name" {
  description = "Optional custom domain name for CloudFront (e.g., app.example.com)"
  type        = string
  default     = ""
}

variable "hosted_zone_id" {
  description = "Route53 hosted zone ID (required if domain_name is set)"
  type        = string
  default     = ""
}

variable "acm_certificate_arn" {
  description = "Optional ACM certificate ARN for CloudFront (if not provided, will be created automatically when domain_name is set)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Additional tags"
  type        = map(string)
  default     = {}
}

variable "additional_origins" {
  description = "Additional CloudFront origins (e.g., for Lambda Function URLs or APIs)"
  type = list(object({
    origin_id   = string
    domain_name = string
    origin_path = optional(string, "")
    custom_header = optional(list(object({
      name  = string
      value = string
    })), [])
  }))
  default = []
}

variable "additional_cache_behaviors" {
  description = "Additional CloudFront cache behaviors"
  type = list(object({
    path_pattern             = string
    target_origin_id         = string
    viewer_protocol_policy   = optional(string, "redirect-to-https")
    allowed_methods          = optional(list(string), ["GET", "HEAD", "OPTIONS", "PUT", "POST", "PATCH", "DELETE"])
    cached_methods           = optional(list(string), ["GET", "HEAD"])
    compress                 = optional(bool, true)
    cache_policy_id          = optional(string)
    origin_request_policy_id = optional(string)
  }))
  default = []
}
