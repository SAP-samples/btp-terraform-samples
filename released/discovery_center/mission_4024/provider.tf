terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta1"
    }
  }
}

provider "btp" {
  # Comment out the idp in case you need it to connect to your global account
  # -------------------------------------------------------------------------
  # idp            = var.custom_idp
  globalaccount  = var.globalaccount
}