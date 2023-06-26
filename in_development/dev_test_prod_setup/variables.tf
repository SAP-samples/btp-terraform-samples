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
    condition     = can(regex("[0-9]{10}", var.costcenter))
    error_message = "Validation of costcenter failed! Only numbers are allowed and costcenter must have 10 digits."
  }

}


variable "project_name" {
  type        = string
  description = "Defines the project name used by the org unit (defined in variable 'org_name')."
  default     = "prj_8472"
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
