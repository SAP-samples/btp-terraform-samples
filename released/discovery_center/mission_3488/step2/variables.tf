# Description: This file contains the input variables for the mission 3488 step 2.
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
# ENVIRONMENTS variables
# ------------------------------------------------------------------------------------------------------
# cloudfoundry (Cloud Foundry Environment)
# ------------------------------------------------------------------------------------------------------
#
variable "cf_api_url" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
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

# User lists
variable "cf_org_managers" {
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

# ------------------------------------------------------------------------------------------------------
# SERVICES (plans and other parameters)
# ------------------------------------------------------------------------------------------------------
# analytics-planning-osb (SAP Analytics Cloud), sac
# ------------------------------------------------------------------------------------------------------
# plans
variable "service_plan__sac" {
  type        = string
  description = "The plan for service 'SAP Analytics Cloud' with technical name 'analytics-planning-osb'"
  default     = "free"
  validation {
    condition     = contains(["free", "production"], var.service_plan__sac)
    error_message = "Invalid value for service_plan__sac. Only 'free' and 'production' are allowed."
  }
}

# (sac) instance parameters
variable "sac_admin_email" {
  type        = string
  description = "SAC Admin Email"
}

variable "sac_admin_first_name" {
  type        = string
  description = "SAC Admin First Name"
}

variable "sac_admin_last_name" {
  type        = string
  description = "SAC Admin Last Name"
}

variable "sac_admin_host_name" {
  type        = string
  description = "SAC Admin Host Name"
}

variable "sac_number_of_business_intelligence_licenses" {
  type        = number
  description = "Number of business intelligence licenses"
  default     = 6
}

variable "sac_number_of_professional_licenses" {
  type        = number
  description = "Number of business professional licenses"
  default     = 1
}

variable "sac_number_of_business_standard_licenses" {
  type        = number
  description = "Number of business standard licenses"
  default     = 2
}

# testing
variable "enable_service_setup__sac" {
  type        = bool
  description = "If true setup of service 'SAP Analytics Cloud' with technical name 'analytics-planning-osb' is enabled"
  default     = true
}
