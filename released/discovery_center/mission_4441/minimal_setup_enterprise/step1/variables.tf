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
  default     = "My SAP Build Code subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# cf related variables
# ------------------------------------------------------------------------------------------------------
variable "origin" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "origin_key" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_landscape_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = "mission-4441-sap-build-code"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
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

# ------------------------------------------------------------------------------------------------------
# service plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__cloudfoundry" {
  type        = string
  description = "The plan for service 'Destination Service' with technical name 'destination'"
  default     = "build-code"
  validation {
    condition     = contains(["build-code"], var.service_plan__cloudfoundry)
    error_message = "Invalid value for service_plan__cloudfoundry. Only 'build-code' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__build_code" {
  type        = string
  description = "The plan for service 'SAP Build Code' with technical name 'build-code'"
  default     = "standard"
  validation {
    condition     = contains(["free", "standard"], var.service_plan__build_code)
    error_message = "Invalid value for service_plan__build_code. Only 'free' and 'standard' are allowed."
  }
}

variable "service_plan__sapappstudio" {
  type        = string
  description = "The plan for service 'SAP Business Application Studio' with technical name 'sapappstudio'"
  default     = "build-code"
  validation {
    condition     = contains(["build-code"], var.service_plan__sapappstudio)
    error_message = "Invalid value for service_plan__sapappstudio. Only 'build-code' is allowed."
  }
}

variable "service_plan__sap_launchpad" {
  type        = string
  description = "The plan for service 'SAP Build Work Zone, standard edition' with technical name 'SAPLaunchpad'"
  default     = "foundation"
  validation {
    condition     = contains(["foundation", "free", "standard"], var.service_plan__sap_launchpad)
    error_message = "Invalid value for service_plan__sap_launchpad. Only 'foundation', 'free' and 'standard' are allowed."
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

variable "build_code_admins" {
  type        = list(string)
  description = "Defines the colleagues who are admins for SAP Build Code."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.build_code_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.build_code_admins)
    error_message = "Please enter a valid email address for the Build Code admins."
  }
}
variable "build_code_developers" {
  type        = list(string)
  description = "Defines the colleagues who are developers for SAP Build Code."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.build_code_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.build_code_developers)
    error_message = "Please enter a valid email address for the Build Code developers."
  }
}

variable "cf_org_admins" {
  type        = list(string)
  description = "List of users to set as Cloudfoundry org administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the CF Org admins."
  }
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_managers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_managers)
    error_message = "Please enter a valid email address for the CF space managers."
  }
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_developers)
    error_message = "Please enter a valid email address for the CF space developers."
  }
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}