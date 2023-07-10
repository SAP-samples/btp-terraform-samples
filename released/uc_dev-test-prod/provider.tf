terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.1.0-beta1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = "terraformdemocanary"
  cli_server_url = "https://cpcli.cf.sap.hana.ondemand.com"
}
