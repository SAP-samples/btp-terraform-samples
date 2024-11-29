###
# Provider configuration
###
variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

###
# Subaccount setup
###
variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "proj-1234"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.project_name))
    error_message = "Provide a valid project name."
  }
}

variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "TST", "PRD"], var.stage)
    error_message = "Select a valid stage for the project account."
  }
}

variable "costcenter" {
  type        = string
  description = "The cost center the account will be billed to."
  default     = "1234567890"

  validation {
    condition     = can(regex("^[0-9]{10}", var.costcenter))
    error_message = "Provide a valid cost center."
  }
}

variable "org_name" {
  type        = string
  description = "Defines to which organisation the project account shall belong to."
  default     = "B2C"

  validation {
    condition = contains(concat(
      // Cross Development
      ["B2B", "B2C", "ECOMMERCE"],
      // Internal IT
      ["PLATFORMDEV", "INTIT"],
      // Financial Services
      ["FSIT"],
    ), var.org_name)
    error_message = "Please select a valid org name for the project account."
  }
}

###
# Entitlement for BAS
###
variable "bas_admins" {
  type        = list(string)
  description = "List of users to assign the Administrator role."

}
variable "bas_developers" {
  type        = list(string)
  description = "List of users to assign the Developer role."
}
variable "bas_service_name" {
  type        =  string
  description = "Service name for Business Application Studio."
  default     = "sapappstudio"

}
variable "bas_plan" {
  type        = string
  description = "Plan name for Business Application Studio."
  default     = "standard"
}