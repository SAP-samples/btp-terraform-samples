# Exercise 1 - Configure the Terraform Provider for SAP BTP

## Goal of this Exercise 🎯

The goal of this exercise is to configure the Terraform provider for SAP BTP. In addition we will create a basic setup of the file structure to implement the Terraform configuration.

## Step 1: Create a new directory

To make use of Terraform you must create several configuration files using the [Terraform configuration language](https://developer.hashicorp.com/terraform/language). Create a new directory named `my-tf-handson` under the folder `SITBLR2024`.

Terraform expects a specific file layout for its configurations. Create the following empty files in the directory `my-tf-handson`:

- `main.tf` - this file will contain the main configuration of the Terraform setup
- `provider.tf` - this file will contain the provider configuration
- `variables.tf` - this file will contain the variables to be used in the Terraform configuration
- `outputs.tf` - this file will contain the outputs of the Terraform configuration
- `terraform.tfvars` - this file will contain your specific variable values

## Step 2: Create the provider configuration

Next we must configure the Terraform provider for SAP BTP. This is done by adding the provider configuration to the `provider.tf` file. You find the information about the required parameters in the documentation of the [Terraform Provider for SAP BTP](https://registry.terraform.io/providers/SAP/btp/latest/docs).

Open the file `provider.tf` and add the following content:

```terraform
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.8.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
}
```

What have we done? First we defined which provider we want to use and which version of the provider we want to use. In this case we want to use the provider `sap/btp` in version `1.8.0` (including potential patch versions). Then we defined the provider configuration. In this case we only need to provide the `globalaccount` parameter where we reference a variable. We will define this variable in the next step.

 > [!NOTE]
 > We do not need any authentication information in this file. We provided the authentication information via environment variables.

Next we must add the required variables to the `variables.tf` file. Open the file `variables.tf` and add the following content:

```terraform
variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
}
```

We have now defined the variable `globalaccount` which is required for the provider configuration. We will provide the value for this variable via the `terraform.tfvars` file. Open
the file `terraform.tfvars` and add the following content:

```terraform
globalaccount = "<YOUR GLOBAL ACCOUNT SUBDOMAIN>"
```

 > [!NOTE]
 > We are using here a naming convention of Terraform to define the variable values. The file `terraform.tfvars` is used to define the variable values. The file is not checked into the source code repository. This is important to keep sensitive information out of the source code repository. When you run Terraform, it will automatically load the variable values from this file.

## Summary

You've now created a basic setup of the Terraform provider including its configuration.

Continue to - [Exercise 2 - Setup of a subaccount](../EXERCISE2/README.md).
