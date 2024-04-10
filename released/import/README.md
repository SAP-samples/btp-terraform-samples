# Import of Terraform resources

## Introduction

In this sample we want to highlight how you can import existing resources on SAP BTP into Terraform to be able to manage them via Terraform. We will show the flow on a simple example by importing a subaccount and a service entitlement for this subaccount.

In a nutshell to execute an import of a Terraform resource you must:

- Define so called import blocks for the resources you want to import to tell Terraform where to find the data for the resources.
- Define the matching Terraform configuration for the resources you want to import.

We will walk through this process in the following sections.

## Prerequisites

To have resources that need to be imported we need to create a subaccount and a service entitlement on SAP BTP using the SAP BTP Cockpit.

Create a subaccount with the following settings:

- Display Name: test-terraform-import
- Region: us-10 (depending on the available regions in your account)

In addition under `Advanced`

- Tick the checkbox "Used for production"
- Add a label with the key "type" and the value "legacy"

The configuration result should look like this:

![Configuration of subaccount](./assets/subaccount-setup.png)

Assign an entitlement to the subaccount for the service "Alert Notification" (technical name `alert-notification`) and the service plan `standard`.

## Data Collection

To configure the resources for the import we must collect the necessary information. For that we must first identify what parameters are needed for the resources. We can determine the needed information via the Terraform provider documentation for the resources.

According to the documentation of the [subaccount resource](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount) the following parameters are needed to match our subaccount setup from the prerequisites:

- `name`
- `region`
- `subdomain`
- `usage`
- `labels`

Besides that we must also check the information about the [import of the resource](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount#import) to see which keys are needed. Here we need the `subaccount_id` which we anyway know from the SAP BTP Cockpit.

According to the documentation of the [entitlement resource](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_entitlement) the following parameters are needed to match our service entitlement setup from the prerequisites:

- `plan_name`
- `service_name`
- `subaccount_id`

As for the subaccount we must check the information about the [import of the resource](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_entitlement#import) to see which keys are needed. Here we need the `subaccount_id`, `service_name` and the `plan_name` which we also need for the resource configuration.

You have different ways to retrieve this data. You can:

- Determine it via the SAP BTP Cockpit.
- Use the BTP CLI to extract the data. We recommend using the `-format json` option.
- Use the Terraform provider namely the data sources for the corresponding resources.
- A combination of the above.

In this repository we provide a setup via data sources in the folder `data-collection`. We leverage the data sources for the subaccount and the service entitlement to collect the necessary information and transfer the data relevant for the import as output variables defined in the `output.tf` file. To execute the data collection for your setup you must create a `terraform.tfvars` file in the `data-collection` folder with the values matching your setup namely:

```terraform
globalaccount = "Global Account Subdomain"
subaccount_id = "ID of the subaccount"
service_name = "Name of the service"
service_plan_name = "Name of the service plan"
```

The flow to execute the data collection is:

- Navigate to the folder `data-collection`
- Execute `terraform init`
- Execute `terraform apply`

The output the gives you the necessary information for the resource configuration.

> **Note** - the data collection via data sources is a bit overenigneered for this simple example. In a real world scenario this can however sacve you a lot of time compared to navigating through the SAP BTP cockpit.

## Configuring the import

As we have gathered all necessary information we can now as a first step configure the resources for the import. We will do this in the in the `resource-import` folder.

We define the input variables that we later need for the configuration as well as for the import of the resources. The input variables are defined in the file `variables.tf` as:

```terraform
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
}

variable "subaccount_region" {
  type        = string
  description = "The subaccount region."
}

variable "subaccount_subdomain" {
  type        = string
  description = "The subaccount subdomain."
}

variable "subaccount_usage" {
  type        = string
  description = "The subaccount usage."
}

variable "subaccount_labels" {
  type        = map(set(string))
  description = "The subaccount labels."
}

variable "service_name" {
  type        = string
  description = "The service name."
}

variable "service_plan_name" {
  type        = string
  description = "The service plan name."
}
```

We supply them via a `terraform.tfvars` file in the same `resource-import` filled with the parameters we collected in the previous step.

We do the configuration for the resources in the `main.tf`:

```terraform
resource "btp_subaccount" "my_imported_subaccount" {
  name      = var.subaccount_name
  subdomain = var.subaccount_subdomain
  region    = var.subaccount_region
  usage     = var.subaccount_usage
  labels    = var.subaccount_labels
}

resource "btp_subaccount_entitlement" "my_imported_entitlement" {
  subaccount_id = resource.btp_subaccount.my_imported_suibaccount.id
  service_name  = var.service_name
  plan_name     = var.service_plan_name
}
```

The configuration should correspond to the configuration you would write when creating the resources from scratch.

The last piece that is missing is the definition of the [import blocks](https://developer.hashicorp.com/terraform/language/import). They provide the connection between the resource configuration and where to find the data for the resource import on the platform. We define them in the `import.tf` file:

```terraform
import {
  to = btp_subaccount.my_imported_subaccount
  id = var.subaccount_id
}

import {
  to = btp_subaccount_entitlement.my_imported_entitlement
  id = "${var.subaccount_id},${var.service_name},${var.service_plan_name}"
}
```

Be awrae of the combined key used for the import of the entitlement resource. The key is a combination of the `subaccount_id`, `service_name` and the `plan_name`.

## Executing the import

## Additional Information

You find more information about the Teraform import functionality in the [Terraform documentation](https://www.terraform.io/docs/cli/import/index.html)