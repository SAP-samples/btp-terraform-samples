terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.9.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.2.0"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
  idp           = var.idp
}
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
  origin  = var.idp
}