# Backend As Artifactory

This terraform backend configuration utilizes Artifactory as a remote [backend](https://developer.hashicorp.com/terraform/language/settings/backends/remote), Storing the state in a workspace of an artifactory.

## Prerequisite

Setup Jfrog Artifactory as a [Terraform backend](https://jfrog.com/help/r/jfrog-artifactory-documentation/set-up-terraform-backend-repository-to-work-with-artifactory)

Generate an [Access Token](https://jfrog.com/help/r/jfrog-artifactory-documentation/generate-an-access-token-for-terraform?tocId=tR8lXeO2OmLkW06RPIY1IQ) for Terraform

## Example Configuration

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
```
Note: Incase if you are getting workspace does not exists error, you can create the workspace using following command.

``` terraform workspace new <WORKSPACE NAME> ```