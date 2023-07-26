terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.2.0-beta2"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.50.8"
    }
  }
}

# Configure the BTP Provider
provider "btp" {
  globalaccount = "4605efebtrial-ga"
}

provider "cloudfoundry" {
  api_url = module.trialaccount.cloudfoundry.api_endpoint
}
