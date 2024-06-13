
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.4.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = "terraformintcanary"
  cli_server_url = "https://canary.cli.btp.int.sap"

}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
}
