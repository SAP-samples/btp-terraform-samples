
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "1.2.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.53.1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount  = var.globalaccount
}

# Get the Cloudfoundry API endpoint
module "cloudfoundry_api" {
  source            = "../../modules/environment/cloudfoundry/apiurl_cf"
  environment_label = var.cf_environment_label
}

// Configuration is described in https://registry.terraform.io/providers/cloudfoundry-community/cloudfoundry/latest/docs
provider "cloudfoundry" {
  api_url = module.cloudfoundry_api.api_url
}