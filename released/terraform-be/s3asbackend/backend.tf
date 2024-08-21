terraform {
  backend "s3" {
    bucket         = "btpterraformbackend"
    key            = "terraform/state"
    region         = "eu-north-1"
    encrypt        = true
    acl            = "bucket-owner-full-control"
  }
}