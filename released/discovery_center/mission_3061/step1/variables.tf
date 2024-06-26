variable "globalaccount" {
  type        = string
  description = "The global account subdomain."
}

variable "subaccount_prefix" {
  type        = string
  description = "The prefix for the subaccount name and subdomain."
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "eu10"
}

variable "cf_plan_name" {
  type        = string
  description = "Desired service plan for the Cloud Foundry environment instance."
  default     = "standard"
}

variable "cf_landscape_label" {
  type        = string
  description = "The Cloud Foundry landscape (format example eu10-004)."
  default     = ""
}

variable "abap_sid" {
  type        = string
  description = "The system ID (SID) of the ABAP system."

  validation {
    condition     = can(regex("^[A-Z][A-Z0-9]{2}$", var.abap_sid))
    error_message = "Please provide a valid system ID (SID). It must consist of exactly three alphanumeric characters. Only uppercase letters are allowed. The first character must be a letter (not a digit). The ID does not have to be technically unique."
  }
}

variable "abap_si_plan" {
  type        = string
  description = "Plan for the service instance of ABAP."
  default     = "standard"
}

variable "abap_compute_unit_quota" {
  type        = number
  description = "The amount of ABAP compute units to be assigned to the subaccount."
  default     = 1
}

variable "hana_compute_unit_quota" {
  type        = number
  description = "The amount of ABAP compute units to be assigned to the subaccount."
  default     = 2
}

variable "custom_idp" {
  type        = string
  description = "Name of custom IDP to be used for the subaccount"
}
