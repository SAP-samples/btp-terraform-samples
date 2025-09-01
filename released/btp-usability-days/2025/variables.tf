variable "globalaccount" {
  description = "The BTP global account name"
  type        = string
}

variable "idp" {
  description = "The Identity Provider to use for authentication (e.g. 'ias' or 'xsuaa')"
  type        = string
  default     = null
}

variable "subaccount_name" {
  description = "The BTP subaccount name"
  type        = string
}

variable "region" {
  description = "The region of the SAP BTP subaccount"
  type        = string
  default     = "us10"
}

variable "stage" {
  description = "The stage of the SAP BTP subaccount"
  type        = string
  default     = "Dev"
  validation {
    condition     = contains(["Dev", "Test", "Prod"], var.stage)
    error_message = "Stage must be one of the following: `Dev`, `Test`, `Prod`."
  }
}

variable "cost_center" {
  description = "The cost center for the SAP BTP subaccount"
  type        = string
}

variable "contact_person" {
  description = "The contact person for the SAP BTP subaccount"
  type        = string
}

variable "department" {
  description = "The department for the SAP BTP subaccount"
  type        = string
}

variable "emergency_subaccount_admins" {
  description = "List of emergency subaccount admins (emails)"
  type        = list(string)
  default     = []
}
