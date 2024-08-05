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
# Entitlements
###

# Plan_name update
variable "service_plan__bas" {
  description = "BAS plan"
  type        = string
  default     = "free"
}

variable "service_plan__build_workzone" {
  description = "Build Workzone plan"
  type        = string
  default     = "free"
}

variable "service_plan__hana_cloud" {
  description = "hana-cloud plan"
  type        = string
  default     = "hana-free"
}

###
# Cloud Foundry
###

variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "The name for the Cloud Foundry Org."
  default     = ""
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
  default     = []
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
  default     = []
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
  default     = []
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
  default     = []
}

variable "create_tfvars_file_for_next_stage" {
  description = "Switch to enable the creation of the tfvars file for the next stage."
  type        = bool
  default     = false
}
