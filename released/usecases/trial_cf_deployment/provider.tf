terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.0.0-rc1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}

# Configure the BTP Provider
provider "btp" {
  globalaccount = "<SUBDOMAIN OF YOUR GLOBAL ACCOUNT>"
}

provider "cloudfoundry" {
  api_url = module.trialaccount.cloudfoundry.api_endpoint
}
