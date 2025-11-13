# Terraform Module - Devcontainer Runtime

This Terraform module is used to provision a devcontainer runtime based on [Kyma](https://github.com/kyma-project/kyma) on [SAP Business Technology Platform (BTP)](https://account.hanatrial.ondemand.com/). It creates a subaccount, sets up entitlements, and deploys a Kyma runtime environment.

## Prerequisites

- [SAP BTP trial account](https://developers.sap.com/tutorials/hcp-create-trial-account.html)
- [terraform CLI](https://developer.hashicorp.com/terraform/install)
- [kubectl CLI](https://github.com/kubernetes/kubectl)
- [kubelogin CLI](https://github.com/int128/kubelogin)
- [devpod CLI](https://github.com/loft-sh/devpod)

Make sure all the CLI tools are installed and can be resolved via the system $PATH.

## Usage

To use this module, include the following code in your Terraform configuration:

```hcl
module "devcontainer_runtime" {
  source         = "github.com/SAP-samples/btp-terraform-samples/released/usecases/kyma_devcontainer_runtime"
  users          = [
    "user1@test.com",
    "user2@test.com",
  ]
}
```

## Inputs

| Name                  | Description                                                      | Type         | Default                   |
|-----------------------|------------------------------------------------------------------|--------------|---------------------------|
| subaccount_name       | The name of the subaccount.                                      | string       | "devcontainer-runtime"    |
| subaccount_subdomain  | The subdomain of the subaccount.                                 | string       | "devcontainer-runtime"    |
| region                | The BTP region the devcontainer runtime shall be created in.     | string       | "us10"                    |
| users                 | Users that shall have access to the runtime.                     | set(string)  | []                        |

## Outputs

| Name                  | Description                                                      | Type         |
|-----------------------|------------------------------------------------------------------|--------------|
| subaccount_id         | The ID of the created subaccount.                                | string       |
| kyma_dashboard        | The URL of the Kyma runtime dashboard.                           | string       |
| kubeconfig            | The kubeconfig file for accessing the Kyma runtime cluster.      | string       |
