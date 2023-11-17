
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta2"
    }
  }
}

provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
