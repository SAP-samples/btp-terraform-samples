
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 0.3"
    }
  }
}

provider "btp" {
  globalaccount = "ticrossa"
  # username      = "your@email.com"
  # password      = "********"
}
