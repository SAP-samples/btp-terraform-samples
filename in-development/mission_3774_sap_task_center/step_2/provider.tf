###
# Define the required providers for this module
###
terraform {
  required_providers {
    btp = {
      source = "sap/btp"
    }
    cloudfoundry = {
      source = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }
  }
}
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
provider "cloudfoundry" {
  api_url  = var.cf_api_url
}
