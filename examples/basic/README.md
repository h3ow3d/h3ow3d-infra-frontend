# Basic Example

This example shows the simplest usage of the frontend module without a custom domain.

## What it creates

- S3 bucket for website hosting
- CloudFront distribution (uses default cloudfront.net domain)
- S3 bucket for build artifacts

## Usage

```bash
cd examples/basic
terraform init
terraform plan
terraform apply
```

## Accessing the site

After deployment, use the CloudFront domain from the output:

```bash
terraform output website_url
```

Example: `https://d111111abcdef8.cloudfront.net`

## Clean Up

```bash
terraform destroy
```
