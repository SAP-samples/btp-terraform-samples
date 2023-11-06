variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "region" {
  type        = string
  description = "The region where the account shall be created in."
  default     = "us10"
}

variable "landscapes" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
  default     = ["DEV", "TST", "PRD"]
}

variable "unit" {
  type        = string
  description = "Defines to which organisation the sub account shall belong to."
  default     = "Research"
}

variable "unit_shortname" {
  type        = string
  description = "Short name for the organisation the sub account shall belong to."
  default     = "Test"
}

variable "architect" {
  type        = string
  description = "Defines the email address of the architect for the subaccount"
  default     = "jane.doe@test.com"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = "terraformint"
}

variable "costcenter" {
  type        = string
  description = "Defines the costcenter for the subaccount"
  default     = "1234567890"
}

variable "owner" {
  type        = string
  description = "Defines the owner of the subaccount"
  default     = "jane.doe@test.com"
}

variable "team" {
  type        = string
  description = "Defines the team of the sub account"
  default     = "sap.team@test.com"
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}
