terraform {
  required_providers {
    cloudfoundry = {
      source = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }

  }
}

provider "cloudfoundry" {
  api_url =  var.cf_api_endpoint
}