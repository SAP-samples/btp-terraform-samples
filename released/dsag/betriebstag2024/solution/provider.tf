terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.5.0"
    }
    cloudfoundry = {
      source  = "sap/cloudfoundry"
      version = "1.0.0-rc1"
    }
  }

}

provider "btp" {
  globalaccount = var.globalaccount
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
}
