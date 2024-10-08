terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.7.0"
    }
  }
}

provider "btp" {
  #idp = var.custom_idp
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}