######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
}
# CLI server URL
variable "cli_server_url" {
  type        = string
  description = "Defines the CLI server URL"
  default     = "https://cli.btp.cloud.sap"
}

# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "UC - Establish a Central Inbox with SAP Task Center"
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
# Cloudfoundry environment label
variable "cf_environment_label" {
  type        = string
  description = "The Cloudfoundry environment label"
  default     = "cf-us10"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
}

variable "environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = "cf-us10"
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = "mission-3774-sap-task-center"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
}

variable "cf_space_name" {
  type        = string
  description = "Name of the Cloud Foundry space."
  default     = "DEV"
}

variable "cfsr_space_manager" {
  type        = string
  description = "Defines the user who are added as space manager."
  default     = "john.doe@test.com"
}

variable "cfsr_space_developer" {
  type        = string
  description = "Defines the user who are added as space developer."
  default     = "john.doe@test.com"
}