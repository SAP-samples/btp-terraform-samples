variable "globalaccount" {
  description = "Subdomain of the global account"
  type        = string
}

variable "parent_id" {
  description = "The parent ID for the subaccount"
  type        = string
  default     = ""
}

variable "project_name" {
  description = "Name of the project"
  type        = string
  default     = "Integration Account"
}

variable "subaccount_stage" {
  description = "Stage of the subaccount"
  type        = string
  default     = "DEV"
  validation {
    condition     = contains(["DEV", "TEST", "PROD"], var.subaccount_stage)
    error_message = "Stage must be one of DEV, TEST or PROD"
  }
}

variable "subaccount_region" {
  description = "Region of the subaccount"
  type        = string
  default     = "us10"
  validation {
    condition     = contains(["us10", "ap21"], var.subaccount_region)
    error_message = "Region must be one of us10 or ap21"
  }
}

variable "cf_landscape_label" {
  description = "Label of the Cloud Foundry landscape"
  type        = string
  default     = "us10-001"
  validation {
    condition     = contains(["us10-001", "ap21"], var.cf_landscape_label)
    error_message = "Landscape must be one of us10-001 or ap21"
  }
}

variable "project_costcenter" {
  description = "Cost center of the project"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{5}$", var.project_costcenter))
    error_message = "Cost center must be a 5 digit number"
  }
}

variable "emergency_admins" {
  description = "List of emergency admins"
  type        = list(string)
  default     = []
}

variable "space_managers" {
  description = "List of space managers"
  type        = list(string)
  default     = []
}

variable "space_developers" {
  description = "List of space developers"
  type        = list(string)
  default     = []

}
