terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta1"
    }
  }
}

provider "btp" {
#  idp            = var.custom_idp

  globalaccount  = var.globalaccount
}