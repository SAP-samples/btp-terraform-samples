
# Terramate Setup for BTP and CF Providers

This guide provides a step-by-step process to create a Terramate-based setup for managing **BTP (Business Technology Platform)** and **CF (Cloud Foundry)** Terraform providers across **dev**, **staging**, and **production** environments.

## Prerequisites

- [Terraform](https://www.terraform.io/downloads.html) installed on your system.
- [Terramate CLI](https://terramate.io/) installed. `brew install terramate` would do for mac.
- Git for version control.
- Credentials for BTP and CF providers.

---

## Directory Structure

Create the following directory structure for your Terramate setup:

```plaintext
terramate_project/
├── stacks/           
│   ├── dev/
│   │   ├── terramate.tm.hcl
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   ├── staging/
│   │   ├── terramate.tm.hcl
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   ├── provider.tf
│   ├── production/
│       ├── terramate.tm.hcl
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       ├── provider.tf
└── terramate.tm.hcl      
```

## Enable git integration within Terramate

Create a directory named `Terraform_Demo` and add below config for git integration.

```hcl
# terramate.tm.hcl
terramate {
  config {
    git {
      enabled = true
      default_branch = "main"
    }
  }
}
```

## Configure Environment-Specific Stacks

Each stack (e.g., `dev`, `production`) uses the shared modules with stack-specific variable overrides.

### **Stack: Dev**
```bash
terramate create stacks/dev
terramate create stacks/prod
```
You can create these stacks manually also, by crearting a file with extension of `tm.hcl` for both `dev` and `prod` stacks like below.

```hcl
stack {
  name        = "dev"
  description = "Development environment stack"
  id          = "dev-stack"
  tags        = ["environment.dev"]
}
```

```hcl
stack {
  name        = "prod"
  description = "Production environment stack"
  id          = "prod-stack"
  tags        = ["environment.prod"]
}
```

Now create `provider.tf` `variables.tf` `main.tf` and `output.tf` in the`dev` `prod` stack directories.

`main.tf`
---
```hcl

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
resource "cloudfoundry_org_role" "my_role" {
  for_each = var.cf_org_user
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

resource "cloudfoundry_space_role" "cf_space_managers" {
  for_each   = toset(var.cf_space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.my_role]
}

resource "cloudfoundry_space_role" "cf_space_developers" {
  for_each   = toset(var.cf_space_developers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.my_role]
}

```

`provider.tf`
```hcl
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.9.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.2.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
  idp           = var.idp
}
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
  origin  = var.idp
}
```
`output.tf`

```hcl
output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}
output "cloudfoundry_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the cloudfoundry org connected to the project account."
}
```

`variable.tf` for `DEV`

```hcl
variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
  default     = "terraformintprod"
}

variable "idp" {
  type        = string
  description = "Orgin key of Identity Provider"
  default     = null
}
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "Terramate"

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
  default     = "B2C"
}
variable "bas_admins" {
  type        = list(string)
  description = "List of users to assign the Administrator role."
  default     = [ "Admin1@test.com","Admin2@test.com" ]

}
variable "bas_developers" {
  type        = list(string)
  description = "List of users to assign the Developer role."
  default     = [ "dev1@test.com","dev2@test.com" ]
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
  default     = "cf-us10-001"
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

variable "cf_org_user" {
  type        = set(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "The list of Cloud Foundry space managers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_developers" {
  type        = list(string)
  description = "The list of Cloud Foundry space developers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

```
`variable.tf` for `PROD`
```hcl
variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
  default = "terraformintprod"
}

variable "idp" {
  type        = string
  description = "Orgin key of Identity Provider"
  default     = null
}
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "Terramte"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.project_name))
    error_message = "Provide a valid project name."
  }
}
variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "PRD"

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
  default     = "B2C"
}
variable "bas_admins" {
  type        = list(string)
  description = "List of users to assign the Administrator role."
  default = [ "admin1@test.com","adminnew@test.com" ]

}
variable "bas_developers" {
  type        = list(string)
  description = "List of users to assign the Developer role."
  default = [ "developer1@test.com","developer2@test.com" ]
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
  default     = "cf-us10-001"
}
variable "cf_plan" {
  type        = string
  description = "Plan name for Cloud Foundry Runtime."
  default     = "standard"
}
variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "prod"
}

variable "cf_org_user" {
  type        = set(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "The list of Cloud Foundry space managers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_developers" {
  type        = list(string)
  description = "The list of Cloud Foundry space developers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}


```
### **Initialize All Stacks**
Run the following command to initialize all stacks:
```bash
terramate run terraform init
```

### **Plan Across All Stacks**
Preview changes across all environments:
```bash
terramate run terraform plan
```

### **Apply Changes for a Specific Stack**
Apply changes in the `dev` stack:
```bash
terramate run terraform apply

```

### Incase of any change on any file

Use this command to run the config only on changed stack.

```bash
terramate run --changed -- terraform apply
```

### filter the environment using tag

```bash
terramate run --tag enviroment.prod terraform apply
```

## Github actions workflow for the PR validation

create a workflow with following content.

```yml
name: Terraform CI/CD

on:
  push:
    branches:
      - main
  pull_request:

jobs:
  terraform:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2

      - name: Terraform Plan
        run: terramate run -- terraform plan
```

## Conclusion

With this setup, you now have a scalable and modular Terramate configuration for managing **BTP** and **CF** providers across multiple environments. Use the shared modules for reusability, and leverage Terramate CLI for efficient stack orchestration.
