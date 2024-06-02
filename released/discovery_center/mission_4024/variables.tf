variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount"
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
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

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}

variable "service_plan__sap_build_apps" {
  type        = string
  description = "The plan for SAP Build Apps subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard", "partner"], var.service_plan__sap_build_apps)
    error_message = "Invalid value for service_plan__sap_build_apps. Only 'free', 'standard' and 'partner' are allowed."
  }
}

variable "service_plan__build_workzone" {
  type        = string
  description = "The plan for build_workzone subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.service_plan__build_workzone)
    error_message = "Invalid value for service_plan__build_workzone. Only 'free' and 'standard' are allowed."
  }
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

variable "users_BuildAppsAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsAdmin' in SAP Build Apps."
}

variable "users_BuildAppsDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsDeveloper' in SAP Build Apps."
}

variable "users_RegistryAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'RegistryAdmin' in SAP Build Apps."
}

variable "users_RegistryDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of RegistryDeveloper' in SAP Build Apps."
}