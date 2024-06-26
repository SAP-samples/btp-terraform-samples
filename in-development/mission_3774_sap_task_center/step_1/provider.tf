###
# Define the required providers for this module
###
terraform {
  required_providers {
    btp = {
      source = "sap/btp"
    }
  }
}
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
