
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
  # Comment out the idp in case you need it to connect to your global account
  # -------------------------------------------------------------------------
  # idp            = var.custom_idp
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}
