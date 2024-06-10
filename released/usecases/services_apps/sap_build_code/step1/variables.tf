variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "setup_ai_launchpad" {
  type        = bool
  description = "Switch to enable the setup of the AI Launchpad."
  default     = true
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"

  # Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for the latest list of regions
  # supported by the AI Core service.
  validation {
    condition     = contains(["eu10-canary", "ap10", "eu10", "eu11", "jp10", "us10"], var.region)
    error_message = "Please enter a valid region for the sub account. Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for regions providing the AI Core service."
  }
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the admins."
  }
}


variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF org as administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the admins."
  }
}

variable "cf_space_manager" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_manager : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_manager)
    error_message = "Please enter a valid email address for the admins."
  }
}

variable "cf_space_developer" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_developer : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_developer)
    error_message = "Please enter a valid email address for the admins."
  }
}

variable "build_code_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.build_code_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.build_code_admins)
    error_message = "Please enter a valid email address for the admins."
  }
}
variable "build_code_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.build_code_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.build_code_developers)
    error_message = "Please enter a valid email address for the admins."
  }
}

variable "cf_environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "identity_provider" {
  type        = string
  description = "The identity provider for the subaccount."
  default     = "sap.ids"

}
