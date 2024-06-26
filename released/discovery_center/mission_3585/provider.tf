terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.3.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
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
  api_url  = var.cf_url
  user     = var.btp_username
  password = var.btp_password
}
=======

terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.3.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
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
  api_url  = var.cf_url
  user     = var.btp_username
  password = var.btp_password
}
>>>>>>> f241fa4c7dbac5a20980a9a27b59698656e87cc5
