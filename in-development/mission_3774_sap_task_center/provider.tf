terraform {
  required_providers {
    btp = {
      source = "sap/btp"
    }
    cloudfoundry = {
      source = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }
  }
}
# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url

}