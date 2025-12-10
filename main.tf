# Main resource definitions go here

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge(var.tags, {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "terraform"
  })
}

# Example:
# resource "aws_example" "main" {
#   name = "${local.name_prefix}-example"
#
#   tags = merge(local.common_tags, {
#     Name = "${local.name_prefix}-example"
#   })
# }
