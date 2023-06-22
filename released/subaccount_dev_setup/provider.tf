
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 0.3"
    }
  }
}

provider "btp" {
  globalaccount = "yourglobalaccount"
  username      = "your@email.com"
  password      = "********"
}
