# Basic Example

This example shows the simplest usage of the frontend module without a custom domain.

**Note:** The module requires the `aws.us_east_1` provider to be configured (for ACM certificate support), even when not using a custom domain. This provider is passed to the module but won't be used unless you add `domain_name`.

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
