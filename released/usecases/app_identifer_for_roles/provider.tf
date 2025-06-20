terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~>1.12.0"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
}
