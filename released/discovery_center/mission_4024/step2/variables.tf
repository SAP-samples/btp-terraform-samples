variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
}