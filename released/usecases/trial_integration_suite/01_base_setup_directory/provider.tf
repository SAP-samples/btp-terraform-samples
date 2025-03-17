terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.10.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
}
