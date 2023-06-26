###
# Customer account setup
###
variable "department_name" {
  type        = string
  description = "The department name."
  default     = "XYZ"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.department_name))
    error_message = "Provide a valid department department name."
  }
}

###
# Costcenter
###
variable "costcenter" {
  type        = string
  description = "The costcenter of an org unit or department."
  default     = "0123456789"

  validation {
    condition     = can(regex("^[0-9]{10}", var.costcenter))
    error_message = "Validation of costcenter failed! Only numbers are allowed and costcenter must have 10 digits."
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
      // EAB customer group
      ["EAB"],
    ), var.org_name)
    error_message = "Please select a valid org name for the project account."
  }
}
/*
variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "TST", "PRD"], var.stage)
    error_message = "Select a valid stage for the project account."
  }
}
*/

###
# BTP ACCOUNT
###
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

variable "project" {
  description = "Map of landscape for a project."
  type        = map(any)

  default = {
    dev-setup = {
      stage  = "DEV"
    },
    tst-setup = {
      stage  = "TST"
    },
    prd-setup = {
      stage  = "PRD"
    }
  }
}
/*
validation {
  condition = length([
    for o in var.project : true
    if contains(["DEV", "TST", "PRD"], o.dev-setup.stage)
  ]) == length(var.rules)
    error_message = "Select a valid stage for the project account."
}
*/