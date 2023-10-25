variable "user_email" {
  type        = string
  description = "The user e-mail which is passed to TF provider for SAP BTP"
}

variable "password" {
  type        = string
  description = "The password which authenticates the user in passed to TF provider for SAP BTP"
  sensitive   = true
}

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
  default = ""
 
#  validation {
#    condition     = can(regex("^[a-z-]", var.custom_idp))
#    error_message = "Please enter a valid entry for the custom-idp of the subaccount."
#  }
}
 
variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}
 
variable "sap_build_apps_service_plan" {
  type        = string
  description = "The plan for sap_build_apps subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.sap_build_apps_service_plan)
    error_message = "Invalid value for sap_build_apps_service_plan. Only 'free' and 'standard' are allowed."
  }
}
 
variable "build_workzone_service_plan" {
  type        = string
  description = "The plan for build_workzone subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.build_workzone_service_plan)
    error_message = "Invalid value for build_workzone_service_plan. Only 'free' and 'standard' are allowed."
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