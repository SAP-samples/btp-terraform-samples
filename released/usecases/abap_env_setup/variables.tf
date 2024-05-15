variable "globalaccount" {
  type        = string
  description = "The global account subdomain."
}

variable "project_name" {
  type        = string
  description = "The prefix for the subaccount name and subdomain."
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "eu10"
}

variable "cf_landscape" {
  type        = string
  description = "The Cloud Foundry landscape (format example eu10-004)."
  default     = "eu10-004"
}

variable "abap_sid" {
  type        = string
  description = "The system ID (SID) of the ABAP system."
}

variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrator."
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

variable "abap_is_development_allowed" {
  type        = bool
  description = "Flag to define if development on the ABAP system is allowed."
  default     = true
}

#variable "custom_idp" {
#  type        = string
#  description = "Name of custom IDP to be used for the subaccount"
#}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
  default     = []
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
  default     = []
}

