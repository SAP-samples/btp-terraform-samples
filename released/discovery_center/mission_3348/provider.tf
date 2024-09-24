
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.6.0"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
