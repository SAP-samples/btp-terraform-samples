######################################################################
# Customer account setup
######################################################################
variable "globalaccount" {
  type        = string
  description = "Defines the global account"
  default     = "yourglobalaccount"
}

variable "cli_server_url" {
  type        = string
  description = "Defines the CLI server URL"
  default     = "https://cli.btp.cloud.sap"
}

variable "cf_api_url" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
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

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = "mission-3808"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
}

# subaccount
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}


variable "origin_key" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
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
