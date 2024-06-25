
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

provider "btp" {
  globalaccount = "<YOUR GLOBALACCOUNT SUBDOMAIN>"
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}.hana.ondemand.com"
}
