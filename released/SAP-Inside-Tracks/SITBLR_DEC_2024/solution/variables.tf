variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "myproj-1234"

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

variable "bas_plan_name" {
  description = "BAS plan"
  type        = string
  default     = "free"
}

variable "bas_developers" {
  description = "BAS developers"
  type        = list(string)
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "bas_admins" {
  description = "BAS Admininstrators"
  type        = list(string)
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "org_name" {
  type        = string
  description = "Defines to which organisation the project account shall belong to."
  default     = "B2C"
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "cf-us10-001"
}

variable "cf_org_user" {
  type        = set(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "The list of Cloud Foundry space managers."
  default     = []
}

variable "cf_space_developers" {
  type        = list(string)
  description = "The list of Cloud Foundry space developers."
  default     = []
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "The list of Cloud Foundry space auditors."
  default     = []
}
