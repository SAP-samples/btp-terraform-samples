# Description: This file contains the input variables for step 2

# The globalaccount subdomain where the sub account shall be created.
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

# ------------------------------------------------------------------------------------------------------
# use case specific variables
# ------------------------------------------------------------------------------------------------------
variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrator."
}

variable "cf_api_url" {
  type        = string
  description = "The API endpoint of the Cloud Foundry environment."
}

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry landscape (format example eu10-004)."
}

variable "create_cf_space" {
  type        = bool
  description = "Determines whether a new CF space should be created. Must be true if no space with the name cf_space_name exists for the Org, yet, and false otherwise."
}

variable "cf_space_name" {
  type        = string
  description = "The name of the CF space to use. If create_cf_space is true a new space with the given name will be created"
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "cf_org_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry org."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
}
