terraform {
  required_providers {
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }
  }
}

######################################################################
# Configure CF provider
######################################################################
provider "cloudfoundry" {
    # resolve API URL from environment instance
    api_url = var.cf_api_url
}