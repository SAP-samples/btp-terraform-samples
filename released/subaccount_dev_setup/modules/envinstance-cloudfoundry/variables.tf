variable "subaccount_id" {
  type        = string
  description = "The ID of the subaccount where cloudfoundry shall be enabled."
}

variable "plan_name" {
  type        = string
  description = "The desired service plan for the cloudfoundry environment instance."
  default     = "standard"
}

variable "environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "instance_name" {
  type        = string
  description = "The name of the cloudfoundry environment instance."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.]{1,32}$", var.instance_name))
    error_message = "Please provide a valid instance name."
  }
}

variable "cloudfoundry_org_name" {
  type        = string
  description = "The name of the cloudfoundry organization."

  validation {
    condition     = can(regex("^.{1,255}$", var.cloudfoundry_org_name))
    error_message = "The cloudfoundry org name must not be emtpy and not exceed 255 characters"
  }
}