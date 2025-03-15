terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.10.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.3.0"
    }
  }

}

provider "btp" {
  globalaccount = var.globalaccount
}

provider "cloudfoundry" {
  api_url = "https://api.cf.${var.cf_landscape_label}.hana.ondemand.com"
}
