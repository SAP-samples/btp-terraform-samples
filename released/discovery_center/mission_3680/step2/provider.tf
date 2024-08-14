terraform {
  required_providers {
    cloudfoundry = {
      source  = "sap/cloudfoundry"
      version = "1.0.0-rc1"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Configure CF provider
# ------------------------------------------------------------------------------------------------------
provider "cloudfoundry" {
  # resolve API URL from environment instance
  api_url = var.cf_api_url
}