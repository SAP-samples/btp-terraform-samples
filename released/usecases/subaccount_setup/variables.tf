###
# BTP ACCOUNT
###
variable "globalaccount" {
  type        = string
  description = "The global account subdomain."
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "dept-XYZ"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.subaccount_name))
    error_message = "Provide a valid project account name."
  }
}

###
# CloudFoundry Org Setup
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
    ), var.cf_org_name)
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

variable "cf_org_user" {
  type        = set(string)
  description = "Defines the colleagues who are added to the Cloud Foundry organization as users."
  default     = []
}

variable "cf_org_managers" {
  type        = set(string)
  description = "Defines the colleagues who are added to the Cloud Foundry organization as org managers."
  default     = []
}

variable "cf_org_billing_managers" {
  type        = set(string)
  description = "Defines the colleagues who are added to the Cloud Foundry organization as org billing managers."
  default     = []
}

variable "cf_org_auditors" {
  type        = set(string)
  description = "Defines the colleagues who are added to the Cloud Foundry organization as org auditors."
  default     = []
}
