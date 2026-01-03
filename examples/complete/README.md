# Complete Example - With Custom Domain

This example shows the full-featured usage with a custom domain, ACM certificate, and DNS configuration.

## What it creates

- S3 bucket for website hosting
- CloudFront distribution with custom domain
- ACM certificate in us-east-1 (for CloudFront)
- Route53 DNS validation records
- Route53 A record pointing to CloudFront
- S3 bucket for build artifacts

## Prerequisites

- Route53 hosted zone for your domain (e.g., `example.com`)
- Get your hosted zone ID:
  ```bash
  aws route53 list-hosted-zones --query 'HostedZones[?Name==`example.com.`].Id' --output text
  ```

## Usage

1. Update `main.tf` with your domain and hosted zone ID
2. Deploy:

```bash
cd examples/complete
terraform init
terraform plan
terraform apply
```

## Certificate Validation

The certificate validation happens automatically via DNS. It may take 5-10 minutes for the certificate to be validated.

## Accessing the site

After deployment, your site will be available at your custom domain:

```bash
terraform output website_url
```

Example: `https://app.example.com`

## Clean Up

```bash
terraform destroy
```
