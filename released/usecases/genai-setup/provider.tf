
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.1.0"
    }
  }
}

provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
