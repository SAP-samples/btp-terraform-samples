terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.8.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.0.0"
    }
  }

}

provider "btp" {
  globalaccount = var.globalaccount
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
}
