terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta1"
    }
  }
}

provider "btp" {
  username       = var.user_email
  password       = var.password
  idp            = var.custom_idp

  globalaccount  = var.globalaccount
}