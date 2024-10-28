###
# Define the required providers for this module
###
terraform {
  required_providers {
    btp = {
      source = "sap/btp"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.0.0"
    }
  }
}
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
provider "cloudfoundry" {
  api_url = var.cf_api_url
}
