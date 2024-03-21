variable "globalaccount" {
  type        = string
  description = "The global account subdomain."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "ABAP-ENV-USECASE-DEV"
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

variable "abap_sid" {
  type        = string
  description = "The system ID (SID) of the ABAP system."
  default     = "NPL"
}

variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrtor."
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

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}
