variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

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

variable "cf_org_admins" {
  type        = list(string)
  description = "List of users to set as Cloudfoundry org administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the CF Org admins."
  }
}

variable "cf_origin" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the cf_origin can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_landscape_label" {
  type        = string
  description = "In case there are multiple landscapes available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "cf_space_name" {
  type        = string
  description = "The Cloud Foundry space name to use"
  default     = "dev"
}

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.ids"
}

variable "create_tfvars_file_for_next_step" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}
