terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "1.5.0"
    }
  }
}

######################################################################
# Configure BTP provider
######################################################################
provider "btp" {
  cli_server_url = var.cli_server_url
  globalaccount  = var.globalaccount
}