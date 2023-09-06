terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.4.0-beta1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}