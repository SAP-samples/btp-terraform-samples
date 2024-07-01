terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.4.0"
    }
  }
}

provider "btp" {
  # Comment out the idp in case you need it to connect to your global account
  # -------------------------------------------------------------------------
  # idp            = var.custom_idp
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
