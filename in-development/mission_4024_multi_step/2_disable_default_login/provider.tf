terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.1.0"
    }
  }
}

provider "btp" {
  idp            = var.custom_idp
  globalaccount  = var.globalaccount
}