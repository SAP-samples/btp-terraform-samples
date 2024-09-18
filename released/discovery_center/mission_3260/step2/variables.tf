# Description: This file contains the input variables for the mission 3260 step 2.
#
# ------------------------------------------------------------------------------------------------------
# Account variables
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# cf related variables
# ------------------------------------------------------------------------------------------------------
variable "origin" {
  type        = string
  description = "Defines the origin of the identity provider"
  default     = "sap.ids"
  # The value for the origin can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "origin_key" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_api_url" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
}

variable "cf_space_name" {
  type        = string
  description = "Name of the Cloud Foundry space."
  default     = "dev"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_space_name))
    error_message = "The Cloud Foundry space name must not be emtpy and not exceed 255 characters."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF org as administrators."
}

variable "cf_org_users" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF org as users."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."
}