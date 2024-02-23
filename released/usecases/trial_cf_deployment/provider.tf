terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.0.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.53.0"
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
