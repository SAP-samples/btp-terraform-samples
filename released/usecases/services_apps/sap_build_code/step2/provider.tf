terraform {
  required_providers {
    cloudfoundry = {
      source = "SAP/cloudfoundry"
      version = "0.1.0-beta"
    }

  }
}

provider "cloudfoundry" {
  api_url =  var.cf_api_endpoint
}