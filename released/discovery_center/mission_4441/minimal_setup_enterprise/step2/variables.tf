# Description: This file contains the input variables for the SAP Build Code step 2.check 

# The globalaccount subdomain where the sub account shall be created.
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

# The subaccount id
variable "subaccount_id" {
  type        = string
  description = "The Global Account subdomain id."
}

# The BTP CLI server URL
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
}

variable "custom_idp_tenant" {
  type        = string
  description = "workaround"
  default     = ""
}

variable "cf_api_url" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

variable "origin_key" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

# The CF Org ID from the Cloud Foundry environment instance
variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
}

# The CF Org name from the Cloud Foundry environment instance
variable "cf_org_name" {
  type        = string
  description = "The Cloud Foundry Org name from the Cloud Foundry environment instance."

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

variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF org as administrators."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."
}
