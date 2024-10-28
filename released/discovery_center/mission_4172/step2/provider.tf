terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.0.0"
    }
    btp = {
      source  = "SAP/btp"
      version = "~> 1.7.0"
    }
  }
}

provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}


provider "cloudfoundry" {
  api_url = var.cf_api_url
}
