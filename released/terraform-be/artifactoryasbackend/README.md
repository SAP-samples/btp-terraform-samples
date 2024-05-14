# Backend As Artifactory

This terraform backend configuration utilizes Artifactory as a remote [backend](https://developer.hashicorp.com/terraform/language/settings/backends/remote), Storing the state in a workspace of an artifactory.

```hcl
terraform {
  backend "remote" {
    hostname     = "<hostname of the artifactory eg: >"
    organization = "<name of the artifactory repository>"

    workspaces {
      name = "my-workspace-"
    }
  }
}