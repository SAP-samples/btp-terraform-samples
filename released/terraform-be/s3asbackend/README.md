# Backend as S3

The Terraform S3 [backend](https://developer.hashicorp.com/terraform/language/settings/backends/s3) allows you to store the Terraform state files in an Amazon S3 bucket, providing a centralized, reliable, and durable storage solution.

## Example Configuration

```terraform
terraform {
  backend "s3" {
    bucket         = "<Name of your S3 bucket>"
    key            = "terraform/state"
    region         = "<Region>"
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}
```