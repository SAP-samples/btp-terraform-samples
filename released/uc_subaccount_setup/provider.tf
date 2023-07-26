
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.2.0-beta2"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
#provider "btp" {
#  globalaccount = "yourglobalaccount_subdomain_id"
#}
