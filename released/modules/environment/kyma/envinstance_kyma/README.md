# Terraform BTP Kyma Runtime Module

This Terraform module is used to create and manage a Kyma Runtime in a BTP (Business Technology Platform) subaccount.

## Usage

```hcl
module "kyma_runtime" {
  source        = "github.com/SAP-samples/released/modules/environment/kyma/envinstance_kyma"
  subaccount_id = "your-subaccount-id"
  name          = "kyma-cluster-name"
  administrators = ["user1@example.com", "user2@example.com"]
}
```

## Providers

| Name | Version |
|------|---------|
| btp  | n/a     |

## Inputs

| Name            | Description                                                                    | Type           | Default | Required |
|-----------------|--------------------------------------------------------------------------------|----------------|---------|:--------:|
| subaccount_id   | The ID of the subaccount.                                                      | `string`       | n/a     | yes      |
| plan            | The kyma service plan to be used.                                              | `string`       | `null`  | no       |
| name            | The name of the kyma cluster.                                                  | `string`       | n/a     | yes      |
| administrators  | Users to be assigned as administrators.                                        | `set(string)`  | `[]`    | no       |
| oidc            | Custom OpenID Connect IdP to authenticate users in your Kyma runtime.          | `object`       | `null`  | no       |
| region          | The region of the kyma environment.                                            | `string`       | `"eu12"`| no       |

## Outputs

| Name           | Description                       |
|----------------|-----------------------------------|
| dashboard_url  | The URL of the Kyma dashboard.    |
| kubeconfig     | The filename of the kubeconfig.   |

## OIDC Object

| Field           | Description   |
|-----------------|---------------|
| issuer_url      | The URL of the OpenID issuer (use the https schema). |
| client_id       | The client ID for the OpenID client. |
| groups_claim    | The name of a custom OpenID Connect claim for specifying user groups. |
| signing_algs    | The list of allowed cryptographic algorithms used for token signing. The allowed values are defined by RFC 7518. |
| username_prefix | The prefix for all usernames. If you don't provide it, username claims other than “email” are prefixed by the issuerURL to avoid clashes. To skip any prefixing, provide the value as -. |
| username_claim  | The name of a custom OpenID Connect claim for specifying a username. |
