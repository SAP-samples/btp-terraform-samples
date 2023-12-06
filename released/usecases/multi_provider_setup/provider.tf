
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "1.0.0-rc1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}

provider "btp" {
  globalaccount = "<YOUR GLOBALACCOUNT SUBDOMAIN>"
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
}
