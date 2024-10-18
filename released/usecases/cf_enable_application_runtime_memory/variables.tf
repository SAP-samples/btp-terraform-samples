######################################################################
# Customer account setup
######################################################################
# global account
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

# Custom IdP
variable "custom_idp" {
  type        = string
  description = "Custom IdP for provider login. Leave empty to use default SAP IdP."
  default     = ""
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = []
}

###
# Cloud Foundry
###

variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "cf-us10"
}

variable "cf_org_name" {
  type        = string
  description = "The name for the Cloud Foundry Org."
  default     = ""
}

