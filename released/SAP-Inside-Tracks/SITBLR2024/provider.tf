terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.5.0"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
  username      = var.btp_username
  password      = var.btp_password
  idp           = var.idp
}