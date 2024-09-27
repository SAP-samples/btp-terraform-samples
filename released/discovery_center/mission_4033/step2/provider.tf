terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.6.0"
    }
  }
}

provider "btp" {
  cli_server_url = var.cli_server_url
  globalaccount  = var.globalaccount
}