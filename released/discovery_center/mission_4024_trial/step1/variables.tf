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
  default     = ""
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

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

variable "use_optional_resources" {
  type        = bool
  description = "optional resources are ignored if value is false"
  default     = true
}

# ------------------------------------------------------------------------------------------------------
# service plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__destination" {
  type        = string
  description = "The plan for service 'Destination Service' with technical name 'destination'"
  default     = "lite"
  validation {
    condition     = contains(["lite"], var.service_plan__destination)
    error_message = "Invalid value for service_plan__destination. Only 'lite' is allowed."
  }
}

variable "service_plan__application_runtime" {
  type        = string
  description = "The plan for service 'Cloud Foundry Runtime' with technical name 'APPLICATION_RUNTIME'"
  default     = "MEMORY"
  validation {
    condition     = contains(["MEMORY"], var.service_plan__application_runtime)
    error_message = "Invalid value for service_plan__application_runtime. Only 'MEMORY' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__sap_identity_services_onboarding" {
  type        = string
  description = "The plan for service 'Cloud Identity Services' with technical name 'sap-identity-services-onboarding'"
  default     = "default"
  validation {
    condition     = contains(["default"], var.service_plan__sap_identity_services_onboarding)
    error_message = "Invalid value for service_plan__sap_identity_services_onboarding. Only 'default' is allowed."
  }
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

variable "service_plan__sap_launchpad" {
  type        = string
  description = "The plan for service 'SAP Build Work Zone, standard edition' with technical name 'SAPLaunchpad'"
  default     = "standard"
  validation {
    condition     = contains(["standard"], var.service_plan__sap_launchpad)
    error_message = "Invalid value for service_plan__sap_launchpad. Only 'standard' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the users who are added to subaccount as administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "launchpad_admins" {
  type        = list(string)
  description = "Defines the users who have the role of 'Launchpad_Admin'."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.launchpad_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.launchpad_admins)
    error_message = "Please enter a valid email address for the launchpad admins."
  }
}

variable "build_apps_admins" {
  type        = list(string)
  description = "Defines the users who have the role of 'BuildAppsAdmin' in SAP Build Apps."
}

variable "build_apps_developers" {
  type        = list(string)
  description = "Defines the users who have the role of 'BuildAppsDeveloper' in SAP Build Apps."
}

variable "build_apps_registry_admin" {
  type        = list(string)
  description = "Defines the users who have the role of 'RegistryAdmin' in SAP Build Apps."
}

variable "build_apps_registry_developer" {
  type        = list(string)
  description = "Defines the users who have the role of RegistryDeveloper' in SAP Build Apps."
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}