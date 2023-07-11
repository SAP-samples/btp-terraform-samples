terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.1.0-beta1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.50.8"
    }
    zipper = {
      source  = "ArthurHlt/zipper"
      version = "0.14.0"
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

provider "zipper" {}
