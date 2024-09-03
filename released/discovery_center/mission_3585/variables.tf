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

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.ids"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "use_optional_resources" {
  type        = bool
  description = "optional resources are ignored if value is false"
  default     = true
}

# ------------------------------------------------------------------------------------------------------
# service plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__cicd_service" {
  type        = string
  description = "The plan for service 'SAP Continuous Integration and Delivery' with technical name 'cicd-service'"
  default     = "default"
  validation {
    condition     = contains(["default"], var.service_plan__cicd_service)
    error_message = "Invalid value for service_plan__cicd_service. Only 'default' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__sapappstudio" {
  type        = string
  description = "The plan for app subscription 'SAP Business Application Studio' with technical name 'sapappstudio'"
  default     = "standard-edition"
  validation {
    condition     = contains(["standard-edition"], var.service_plan__sapappstudio)
    error_message = "Invalid value for service_plan__sapappstudio. Only 'standard-edition' is allowed."
  }
}

variable "service_plan__sap_launchpad" {
  type        = string
  description = "The plan for app subscription 'SAP Build Work Zone, standard edition' with technical name 'SAPLaunchpad'"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.service_plan__sap_launchpad)
    error_message = "Invalid value for service_plan__sap_launchpad. Only 'free' and 'standard' are allowed."
  }
}

variable "service_plan__cicd_app" {
  type        = string
  description = "The plan for app subscription 'SAP Continuous Integration and Delivery' with technical name 'cicd-app'"
  default     = "free"
  validation {
    condition     = contains(["build-code", "free", "default"], var.service_plan__cicd_app)
    error_message = "Invalid value for service_plan__cicd_app. Only 'build-code', 'free' and 'standard' are allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "launchpad_admins" {
  type        = list(string)
  description = "Defines the colleagues who are Launchpad Admins."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.launchpad_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.launchpad_admins)
    error_message = "Please enter a valid email address."
  }
}

variable "bas_admins" {
  type        = list(string)
  description = "Defines the colleagues who are admins for SAP Business Application Studio."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.bas_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.bas_admins)
    error_message = "Please enter a valid email address."
  }
}

variable "bas_developers" {
  type        = list(string)
  description = "Defines the colleagues who are developers for SAP Business Application Studio."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.bas_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.bas_developers)
    error_message = "Please enter a valid email address."
  }
}

variable "cicd_developers" {
  type        = list(string)
  description = "Defines the colleagues who are developers for the CI/CD service."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cicd_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cicd_developers)
    error_message = "Please enter a valid email address."
  }
}

variable "cicd_admins" {
  type        = list(string)
  description = "Defines the colleagues who are developers for the CI/CD service."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cicd_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cicd_admins)
    error_message = "Please enter a valid email address."
  }
}