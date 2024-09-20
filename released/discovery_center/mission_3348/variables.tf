######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "DC Mission 3348"
}

# subaccount id
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
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
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
}

variable "custom_idp_apps_origin_key" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.custom"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
}

# service plan sap analytics cloud
variable "service_plan__sap_analytics_cloud" {
  type        = string
  description = "The service plan for the SAP Analytics Cloud."
  default     = "free"
  validation {
    condition     = contains(["free", "production"], var.service_plan__sap_analytics_cloud)
    error_message = "Invalid value for service_plan__sap_analytics_cloud. Only 'free' & 'production' are allowed."
  }
}

# SAC User Info

# first name
variable "sac_admin_first_name" {
  type        = string
  description = "SAC Admin First Name"
  default     = "first name"
}

# last name
variable "sac_admin_last_name" {
  type        = string
  description = "SAC Admin Last Name"
  default     = "last name"
}

# email
variable "sac_admin_email" {
  type        = string
  description = "SAC Admin Email"
}

# host_name
variable "sac_admin_host_name" {
  type        = string
  description = "SAC Admin Host Name"
  default     = ""
}

variable "sac_number_of_business_intelligence_licenses" {
  type        = number
  description = "Number of business intelligence licenses"
  default     = 25
}


variable "sac_number_of_professional_licenses" {
  type        = number
  description = "Number of business professional licenses"
  default     = 1
}

variable "sac_number_of_business_standard_licenses" {
  type        = number
  description = "Number of business standard licenses"
  default     = 10
}
