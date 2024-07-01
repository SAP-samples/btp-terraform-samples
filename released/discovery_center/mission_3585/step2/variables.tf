variable "cf_api_url" {
  type        = string
  description = "The API URL of the Cloud Foundry environment instance."
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

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID to use."
}

variable "cf_origin" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the cf_origin can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_space_name" {
  type        = string
  description = "The Cloud Foundry Space name to use."
  default     = "dev"
}