# SAP BTP subaccount setup module

This modules simplifies the creation and management of subaccounts with the SAP BTP Terraform provider and the Cloud Foundry community provider. The modules hides the technical details of both of the providers and provides a simple interface to create and manage subaccounts. It comes with the following features:

- Creation and labelling of subaccounts
- entitlement of services
- subscription to applications / services
- role collection assignment to users
- creation of CF environments including orgs and spaces
- management of users and roles on org and space level

## Usage

```hcl
module "subaccount_setup" {
    source               = "sit/btp/subaccount_setup"
    subaccount_name      = "My Subaccount"
    subaccount_subdomain = "my-subaccount"
    region               = "eu20"
    labels = {
      Stage = ["Development"]
    }
    entitlements = [
      {
        type   = "service"
        name   = "sapappstudio"
        plan   = "standard-edition"
        amount = null
      },
    ]
    subscriptions = [
      {
        app  = "sapappstudio"
        plan = "standard-edition"
      },
    ]
    role_collection_assignments = [
      {
        role_collection_name = "Subaccount Viewer"
        users                = ["john.doe@test.com", "jane.doe@test.com"]
      },
      {
        role_collection_name = "Business_Application_Studio_Developer"
        users                = ["john.doe@test.com"]
      },
    ]
    cf_env_instance_name    = "my-cf-env-instance"
    cf_org_name             = "my-cf-org"
    cf_org_managers         = ["john.doe@test.com"]
    cf_org_billing_managers = ["jane.doe@test.com"]
    cf_org_auditors         = ["jane.doe@test.com"]
    cf_spaces = [
      {
        space_name       = "dev"
        space_managers   = ["john.doe@test.com"]
        space_developers = ["jane.doe@test.com"]
        space_auditors   = ["jane.doe@test.com"]
      },
    ]
}
```

## Inputs

| Name                        | Description                                                     | Type               | Default |
| --------------------------- | --------------------------------------------------------------- | ------------------ | ------- |
| subaccount_name             | Name of the subacccount                                         | `string`           | -       |
| subaccount_subdomain        | Subdomain for the subaccount                                    | `string`           | -       |
| region                      | Region where the subaccount will be running                     | `string`           | -       |
| parent_directory_id         | Id of the parent directory or null for global account as parent | `string`           | `null`  |
| subaccount_labels           | Labels for the subaccount                                       | `map(set(string))` | `null`  |
| entitlements                | List of entitlements for the subaccount                         | `list(object)`     | `[]`    |
| subscriptions               | List of subscriptions for the subaccount                        | `list(object)`     | `[]`    |
| role_collection_assignments | List of role collection assignments for the subaccount          | `list(object)`     | `[]`    |
| cf_env_instance_name        | Name of the Cloud Foundry environment instance                  | `string`           | `""`    |
| cf_org_name                 | Name of the Cloud Foundry org.                                  | `string`           | `""`    |
| cf_org_managers             | List of Cloud Foundry org managers                              | `list(string)`     | `[]`    |
| cf_org_billing_managers     | List of Cloud Foundry org billing managers                      | `list(string)`     | `[]`    |
| cf_org_auditors             | List of Cloud Foundry org auditors                              | `list(string)`     | `[]`    |
| cf_spaces                   | List of Cloud Foundry spaces                                    | `list(object)`     | `[]`    |

## Outputs

| Name               | Description                                   | Type     |
| ------------------ | --------------------------------------------- | -------- |
| subaccount_id      | Technical ID of the subaccount                | `string` |
| cf_env_instance_id | ID of the Cloud Foundry environment instance  | `string` |
| cf_org_id          | ID of the Cloud Foundry org                   | `string` |
| cf_api_endpoint    | API endpoint of the Cloud Foundry environment | `string` |

Further samples can be found in the `examples` folder and serve as basis for your own subaccount setup.

## Providers

| Name                                                                                                                   | Version     |
| ---------------------------------------------------------------------------------------------------------------------- | ----------- |
| [Terraform provider for SAP BTP](https://registry.terraform.io/providers/SAP/btp/latest)                               | 0.4.0-beta1 |
| [Cloud Foundry community provider](https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest) | ~>0.53.0    |
