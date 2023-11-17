
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta2"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.81.0"
    }

  }
}

provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}

# Configure the Microsoft Azure Provider
#provider "azurerm" {
#  skip_provider_registration = true # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
#  features {}
#}