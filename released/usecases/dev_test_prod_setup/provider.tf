terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.6.0-beta2"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
}

// doesn't work for regions with multiple CF environments, e.g. eu10
// (https://help.sap.com/docs/btp/sap-business-technology-platform/regions)
provider "cloudfoundry" {
  api_url  = "https://api.cf.${var.region}.hana.ondemand.com"
}