terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.5.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "1.0.0-rc1"
    }
  }
}

######################################################################
# Configure BTP provider
######################################################################
provider "btp" {
  cli_server_url = var.cli_server_url
  globalaccount  = var.globalaccount
}

######################################################################
# Configure CF provider
######################################################################
provider "cloudfoundry" {
  # resolve API URL from environment instance
  api_url = var.cf_api_url
}