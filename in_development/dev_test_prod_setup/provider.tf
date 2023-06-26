
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.1.0-beta1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = "yourglobalaccountsubdomainid"

}
