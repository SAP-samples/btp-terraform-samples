
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = ">=1.0.0"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = ">=0.53.1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
  username       = var.btp_username
  password       = var.btp_password
  
}
provider "cloudfoundry" {
  api_url  = "https://api.cf.${var.region}.hana.ondemand.com"
  user = var.btp_username
  password = var.btp_password
}
