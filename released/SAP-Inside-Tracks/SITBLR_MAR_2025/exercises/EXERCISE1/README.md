# Setup of a Subaccount using BTP Terraform Provider

In this exercise you will learn how to use the [Terraform Provider for SAP BTP](https://registry.terraform.io/providers/SAP/btp/latest/docs) to provision and manage resources in SAP BTP as well as [Cloudfoundry Terraform Provider](https://registry.terraform.io/providers/cloudfoundry/cloudfoundry/latest) to manage Cloudfoundry resources.

## Step 1: Create a new directory

To make use of Terraform you must create several configuration files using the [Terraform configuration language](https://developer.hashicorp.com/terraform/language). Create a new directory named `my-tf-handson`.

Terraform expects a specific file layout for its configurations. Create the following empty files in the directory `my-tf-handson`:

- `main.tf` - this file will contain the main configuration of the Terraform setup
- `provider.tf` - this file will contain the provider configuration
- `variables.tf` - this file will contain the variables to be used in the Terraform configuration
- `terraform.tfvars` - this file will contain your specific variable values

## Step 2: Setup Subaccount using Terraform

- Open the file `provider.tf` and add the following content:

```terraform
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.10.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.3.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
  idp           = var.idp
}
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
  origin  = var.idp
}
```

What have we done? First we defined which provider we want to use and which version of the provider we want to use. In this case we want to use the provider `sap/btp` in version `1.10.0` and cloudfoundry provider `cloudfoundry/cloudfoundry` in version `1.3.0`. Then we defined the provider configuration. In this case we need to provide the `globalaccount` and `idp` parameters where we reference a variable. We will define this variable in the next steps.

 > [!NOTE]
 > We do not need any authentication information in this file. We provided the authentication information via environment variables.

Next we must add the required variables to the `variables.tf` file. Open the file `variables.tf` and add the following content:

```terraform
variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
}

variable "idp" {
  type        = string
  description = "Orgin key of Identity Provider"
  default     = null
}
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "ap10"
}
variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "proj-1234"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.project_name))
    error_message = "Provide a valid project name."
  }
}
variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "TST", "PRD"], var.stage)
    error_message = "Select a valid stage for the project account."
  }
}
variable "costcenter" {
  type        = string
  description = "The cost center the account will be billed to."
  default     = "1234567890"

  validation {
    condition     = can(regex("^[0-9]{10}", var.costcenter))
    error_message = "Provide a valid cost center."
  }
}
variable "org_name" {
  type        = string
  description = "Defines to which organization the project account shall belong to."
  default     = "Exporter"
}
variable "bas_admins" {
  type        = list(string)
  description = "List of users to assign the Administrator role."

}
variable "bas_developers" {
  type        = list(string)
  description = "List of users to assign the Developer role."
}
variable "bas_service_name" {
  type        = string
  description = "Service name for Business Application Studio."
  default     = "sapappstudio"

}
variable "bas_plan" {
  type        = string
  description = "Plan name for Business Application Studio."
  default     = "standard-edition"
}

variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "cf-ap10"
}
variable "cf_plan" {
  type        = string
  description = "Plan name for Cloud Foundry Runtime."
  default     = "standard"
}
variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

```
We have now defined the variables which will be required for the provider configuration. We will provide the value for this variable via the `terraform.tfvars` file. 

 - Open the file `terraform.tfvars` and add the following content:

```terraform
globalaccount = "<YOUR GLOBAL ACCOUNT SUBDOMAIN>"
idp = null
project_name  = "<YOUR LAST NAME>"

bas_service_name = "sapappstudio" 
bas_plan = "standard-edition"
bas_admins = ["admin1@example.com", "admin2@example.com"]
bas_developers = ["dev1@example.com", "dev2@example.com"]

cf_plan = "standard" 
```
The SAP BTP Global Account Subdomain can be found in the [SAP BTP Cockpit](https://apac.cockpit.btp.cloud.sap/cockpit/?idp=aviss4yru.accounts.ondemand.com#/globalaccount/6378f0c6-1b1e-4b10-8517-171cbec05c3e). Update fields with your user details.

- Open `main.tf` file and add the following content

```terraform
locals {
  project_subaccount_name   = "${var.org_name} | ${var.project_name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.project_name}-${var.stage}", " ", ""))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.project_name)}-${lower(var.stage)}", " ", "_")
}
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  labels = {
    "stage"      = ["${var.stage}"],
    "costcenter" = ["${var.costcenter}"]
  }
}
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.project.id
  service_name  = var.bas_service_name
  plan_name     = var.bas_plan
}

resource "btp_subaccount_subscription" "bas" {
  subaccount_id = btp_subaccount.project.id
  app_name      = var.bas_service_name
  plan_name     = var.bas_plan
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_admin" {
  for_each             = toset(var.bas_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_developer" {
  for_each             = toset(var.bas_developers)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  landscape_label  = var.cf_landscape_label
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.cf_plan
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "30m"
  }
}

resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

```
### Apply the Terraform configuration

Now the moment has come to apply the Terraform configuration for the first time. Open a terminal window and execute the following commands:

1. Initialize the Terraform configuration to download the required provider:

```bash
terraform init
```

> [!NOTE]
> Check your files. You should have a new folder called `.terraform` as well as new file called `.terraform.lock.hcl` in your directory. This means that the Terraform provider has been successfully downloaded and the version constraints are stored for your setup.

2. Plan the Terraform configuration to see what will be created:

```bash
terraform plan
```
3. Apply the Terraform configuration to create the subaccount:

```bash
terraform apply

```
 You will be prompted to confirm the creation of the subaccount. Type `yes` and press `Enter` to continue.

 Go to the BTP cockpit and check the resources you have created. Follow the URL to access [BTP Accounts Cockpit](https://apac.cockpit.btp.cloud.sap/cockpit/?idp=aviss4yru.accounts.ondemand.com#/globalaccount/6378f0c6-1b1e-4b10-8517-171cbec05c3e).


## Summary

You have successfully created an SAP BTP Subaccount with active resources using Terraform. Now, imagine you already have an existing subaccount and want to bring it under Terraform's management. This exercise will guide you through that process.

Continue to - [Exercise 2 - Export BTP Subaccount Using BTP Terraform Exporter](../EXERCISE2/README.md).