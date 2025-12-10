# Contributing to [MODULE_NAME]

Thank you for contributing!

## Development Setup

### Prerequisites

- Terraform >= 1.14.1
- Pre-commit (`brew install pre-commit`)
- TFLint (`brew install tflint`)
- terraform-docs (`brew install terraform-docs`)

### Setup

```bash
git clone https://github.com/h3ow3d/[MODULE_NAME].git
cd [MODULE_NAME]
pre-commit install
```

## Development Workflow

### 1. Make Changes

Edit the Terraform files:
- `main.tf` - Resource definitions
- `variables.tf` - Input variables
- `outputs.tf` - Output values
- `versions.tf` - Terraform/provider versions

### 2. Test Locally

```bash
# Format code
terraform fmt -recursive

# Validate
terraform init -backend=false
terraform validate

# Test examples
cd examples/basic
terraform init
terraform plan
```

### 3. Update Documentation

Documentation is auto-generated from code comments. Update descriptions in:
- Variable `description` fields
- Output `description` fields
- Resource comments

Run terraform-docs manually:
```bash
terraform-docs markdown table . > README.md
```

Or let pre-commit do it automatically on commit.

### 4. Commit Changes

Use [Conventional Commits](https://www.conventionalcommits.org/):

```bash
git commit -m "feat: add new variable for timeout configuration"
git commit -m "fix: correct default value for port"
git commit -m "docs: update usage examples"
git commit -m "feat!: remove deprecated variable (BREAKING CHANGE)"
```

Pre-commit hooks will:
- Format code
- Generate docs
- Run linting

### 5. Create Pull Request

- Title: Use conventional commit format
- Description: Explain the changes and why
- Link any issues

### 6. Release

To create a release:
```bash
git commit -m "feat: new feature description [release]"
git push origin main
```

The `[release]` tag triggers automatic versioning and GitHub release.

## Module Guidelines

### Variables

```hcl
variable "example" {
  description = "Clear description of what this variable does"
  type        = string
  default     = "sensible-default"  # Optional: provide defaults where appropriate
}
```

### Outputs

```hcl
output "example_id" {
  description = "ID of the example resource"
  value       = aws_example.main.id
}
```

### Resources

```hcl
resource "aws_example" "main" {
  name = "${var.project_name}-${var.environment}-example"
  
  # Use merge for tags
  tags = merge(var.tags, {
    Name = "${var.project_name}-${var.environment}-example"
  })
}
```

### Best Practices

✅ Always provide variable descriptions  
✅ Use sensible defaults where possible  
✅ Output all resource IDs/ARNs that might be needed  
✅ Use `merge()` for tags  
✅ Follow AWS naming conventions  
✅ Enable encryption by default  
✅ Use security best practices  

## Versioning

- **MAJOR** (v1.0.0 → v2.0.0): Breaking changes (incompatible API)
- **MINOR** (v1.0.0 → v1.1.0): New features (backward compatible) 
- **PATCH** (v1.0.0 → v1.0.1): Bug fixes

## Questions?

Open an issue for discussion!
