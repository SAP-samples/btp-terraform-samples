
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

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
  cli_server_url = var.cli_server_url
  username      = var.username
  password      = var.password
}

# Get the Cloudfoundry API endpoint
module "cloudfoundry_api" {
  source            = "../modules/envinstance-cloudfoundry-apiurl"
  environment_label = var.cf_environment_label
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url = module.cloudfoundry_api.api_url
  user      = var.username
  password      = var.password
}