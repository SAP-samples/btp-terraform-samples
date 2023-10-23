###
# Customer account setup
###
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "dept-XYZ"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.name))
    error_message = "Provide a valid project account name."
  }
}

variable "cf_org_name" {
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

variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "TST", "PRD"], var.stage)
    error_message = "Select a valid stage for the project account."
  }
}


###
# BTP ACCOUNT
###
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
