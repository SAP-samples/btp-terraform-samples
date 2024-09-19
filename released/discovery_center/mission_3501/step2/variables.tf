variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

# The BTP CLI server URL
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

# The CF Org name from the Cloud Foundry environment instance
variable "cf_org_name" {
  type        = string
  description = "The Cloud Foundry Org name from the Cloud Foundry environment instance."

}

variable "cf_api_url" {
  type = string
}

variable "cf_org_id" {
  type = string
}

variable "subaccount_id" {
  type = string
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if CF Space developers contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_developers)
    error_message = "Please enter a valid email address for the CF Space developers."
  }
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if CF Space managers contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_managers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_managers)
    error_message = "Please enter a valid email address for the Cloud Connector Administrators."
  }
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if CF Org Admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the CF Org Admins."
  }
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if CF Org Users contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_users : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_users)
    error_message = "Please enter a valid email address for the CF Org Users."
  }
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
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
