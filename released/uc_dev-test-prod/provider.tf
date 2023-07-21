terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      # at least 0.2.0 is needed as the script requires capabilities that
      # are not available in previous releases
      version = "0.1.0-beta1"
    }
  }
}

# Please checkout documentation on how best to authenticate against SAP BTP
# via the Terraform provider for SAP BTP
provider "btp" {
  globalaccount = "test"
}

provider "btp" {
  alias = "canary"
  globalaccount = var.globalaccount_canary
  cli_server_url = "https://cpcli.cf.sap.hana.ondemand.com"
}

variable "my_globalaccount" {
  type        = string
  description = "The globalaccount where the sub account shall be created."
  default     = "your_global_account_subdomain"
}

variable "globalaccount_canary" {
  type        = string
  description = "The globalaccount where the sub account shall be created."
  default     = "terraformdemocanary"
}