
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "1.0.0-rc2"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }

}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = "<YOUR GLOBALACCOUNT SUBDOMAIN>"
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
}
