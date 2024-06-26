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


variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
}

variable "origin" {
  type        = string
  description = "The IAS of the user configuration for the cloudfoundry environment"
  default     = "sap.ids"
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}

variable "org" {
  type        = string
  description = "Your SAP BTP org e.g. department"
  default     = "org"
}

variable "environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
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

variable "bas_service_plan" {
  type        = string
  description = "The plan for SAP Business Application Studio subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard-edition"], var.bas_service_plan)
    error_message = "Invalid value for SAP Business Application Studion. Only 'free' and 'standard-edition' are allowed."
  }
}

variable "cicd_service_plan" {
  type        = string
  description = "The plan for Continous Integraion & Delivery subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "default"], var.cicd_service_plan)
    error_message = "Invalid value for Continous Integraion & Delivery. Only 'free' and 'default' are allowed."
  }
}

variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

variable "developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as developers."
}

variable "btp_username" {
  type        = string
  description = "SAP BTP user name"
}


variable "btp_password" {
  type        = string
  description = "Password for SAP BTP user"
  sensitive   = true
}
variable "cf_url" {
  type    = string
  default = "URL to Cloud Foundry landscape"
}
variable "cf_space" {
  type        = string
  description = "Name of the cloud foundry space"
}
