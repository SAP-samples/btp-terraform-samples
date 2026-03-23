# Backend As Artifactory

This terraform backend configuration utilizes [Artifactory](https://jfrog.com/artifactory/) as a remote [backend](https://developer.hashicorp.com/terraform/language/settings/backends/remote), Storing the state in a workspace of an Artifactory repository.

## Prerequisite

Setup Jfrog Artifactory as a [Terraform backend](https://docs.jfrog.com/artifactory/docs/terraform-opentofu-and-terraform-backend-repositories#configure-your-terraform-client-for-terraform-backend)

Generate an [Access Token](https://docs.jfrog.com/administration/docs/configure-workers-for-custom-flows#step-1-configure-jfrog-credential-for-terraform-provider) for Terraform

## Example Configuration

```hcl
terraform {
  backend "remote" {
    hostname     = "<hostname of the artifactory>"
    organization = "<name of the artifactory repository>"

    workspaces {
      name = "<WORKSPACE NAME>"
    }
  }
}
```
Note: Incase if you are getting workspace does not exists error, you can create the workspace using following command.

``` terraform workspace new <WORKSPACE NAME> ```
