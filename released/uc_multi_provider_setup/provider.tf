
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.2.0-beta2"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.50.8"
    }
  }
}

provider "btp" {
  globalaccount = "ourglobalaccount_subdomain_id"
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url  = "https://api.cf.us10.hana.ondemand.com"
}
