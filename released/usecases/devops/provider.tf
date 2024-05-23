
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.3.0"
    }
    cloudfoundry = {
      source = "SAP/cloudfoundry"
      version = "0.2.1-beta"
    }
  }  
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = var.globalaccount
  username      = var.btp_username
  password      = var.btp_password
  
}
provider "cloudfoundry" {
    api_url   = var.cf_url
    user      = var.btp_username
    password  = var.btp_password
}