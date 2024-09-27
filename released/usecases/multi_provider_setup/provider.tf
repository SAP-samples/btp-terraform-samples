
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.7.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "1.0.0-rc1"
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