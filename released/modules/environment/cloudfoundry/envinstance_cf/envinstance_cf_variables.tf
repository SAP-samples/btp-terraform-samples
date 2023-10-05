variable "instance_name" {
  type        = string
  description = "Name of the Cloud Foundry environment instance."

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-\\.]{1,32}$", var.instance_name))
    error_message = "Please provide a valid instance name (^[a-zA-Z0-9_\\-\\.]{1,32})."
  }
}

variable "subaccount_id" {
  type        = string
  description = "ID of the subaccount where the Cloud Foundry environment shall be enabled."
}

variable "plan_name" {
  type        = string
  description = "Desired service plan for the Cloud Foundry environment instance."
  default     = "standard"
}

variable "environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
}

variable "cf_org_managers" {
  type        = list(string)
  description = "List of Cloud Foundry org managers."
}

variable "cf_org_billing_managers" {
  type        = list(string)
  description = "List of Cloud Foundry org billing managers."
}

variable "cf_org_auditors" {
  type        = list(string)
  description = "List of Cloud Foundry org auditors."
}