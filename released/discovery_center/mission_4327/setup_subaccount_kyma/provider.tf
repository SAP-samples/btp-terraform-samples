terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "1.1.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~> 0.53.1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url  = "https://api.cf.${var.region}.hana.ondemand.com"
}


