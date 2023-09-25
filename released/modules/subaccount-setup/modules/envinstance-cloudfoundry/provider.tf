terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.4.0-beta1"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}