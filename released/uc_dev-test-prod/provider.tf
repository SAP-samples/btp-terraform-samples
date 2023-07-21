terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      # at least 0.2.0 is needed as the script requires capabilities that
      # are not available in previous releases
      version = "0.2.0-beta1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
  cli_server_url = var.cli_server_url
}