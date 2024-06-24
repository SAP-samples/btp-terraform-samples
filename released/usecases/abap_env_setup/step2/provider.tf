terraform {
  required_providers {
    cloudfoundry = {
      source  = "sap/cloudfoundry"
      version = "0.2.1-beta"
    }
  }
}

# This will only work if we know the region in advance
provider "cloudfoundry" {
  api_url = var.cloudfoundry_api_url
}
