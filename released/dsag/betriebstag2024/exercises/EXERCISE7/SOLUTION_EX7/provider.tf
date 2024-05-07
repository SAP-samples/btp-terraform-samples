
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.3.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.53.1"
    }
  }

}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
}
