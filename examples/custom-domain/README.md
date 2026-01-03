# Custom Domain Example

This example demonstrates how to configure a custom domain for your frontend application.

## What it creates

- ACM certificate in us-east-1 (required for CloudFront)
- Route53 DNS validation records (automatic)
- Route53 A record pointing to CloudFront
- All standard frontend resources (S3, CloudFront, artifacts bucket)

## Prerequisites

1. **Route53 Hosted Zone**: You must have a hosted zone for your domain
   ```bash
   # Find your hosted zone ID
   aws route53 list-hosted-zones --query 'HostedZones[?Name==`example.com.`].Id' --output text
   ```

2. **Domain ownership**: You must own the domain and have it configured in Route53

## Configuration

Edit `main.tf` and update:

```hcl
# Update the hosted zone lookup
data "aws_route53_zone" "main" {
  name         = "yourdomain.com"  # Change this
  private_zone = false
}

# Update the domain name
module "frontend" {
  # ...
  domain_name = "app.yourdomain.com"  # Change this
}
```

## Usage

```bash
cd examples/custom-domain
terraform init
terraform plan
terraform apply
```

## Certificate Validation

The ACM certificate validation happens automatically via DNS records created in Route53. This typically takes 5-10 minutes.

Terraform will wait for validation to complete before creating the CloudFront distribution.

## After Deployment

Your site will be accessible at your custom domain:

```bash
terraform output website_url
# Output: https://app.example.com
```

## Important Notes

- **us-east-1 Provider Required**: ACM certificates for CloudFront must be in us-east-1
- **DNS Propagation**: After deployment, DNS changes may take a few minutes to propagate
- **Certificate Lifecycle**: The certificate is automatically renewed by AWS

## Clean Up

```bash
terraform destroy
```

Note: The ACM certificate and Route53 records will be deleted, but the hosted zone remains.
