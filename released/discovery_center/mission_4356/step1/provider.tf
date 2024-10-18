terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.7.0"
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