variable "globalaccount" {
  type        = string
  description = "The global account subdomain."
}

variable "subaccount_prefix" {
  type        = string
  description = "The prefix for the subaccount name and subdomain."
  default     = "ABAP-"
}

variable "subaccount_name" {
  type        = string
  description = "The name for the subaccount."
  default     = ""
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
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

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "cf_org_managers" {
  type        = list(string)
  description = "List of Cloud Foundry org managers."
  default     = []
}

variable "cf_org_billing_managers" {
  type        = list(string)
  description = "List of Cloud Foundry org billing managers."
  default     = []
}

variable "cf_org_auditors" {
  type        = list(string)
  description = "List of Cloud Foundry org auditors."
  default     = []
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
  default     = []
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
  default     = []
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "The list of Cloud Foundry space auditors."
  default     = []
}

variable "abap_sid" {
  type        = string
  description = "The system ID (SID) of the ABAP system. It must consist of exactly three alphanumeric characters. Only uppercase letters are allowed. The first character must be a letter (not a digit). The ID does not have to be technically unique."
  default     = "A01"
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

variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrator."
  default     = ""
}

variable "abap_admin" {
  type        = list(string)
  description = "Email of the ABAP Administrator."
  default     = []
}

variable "abap_is_development_allowed" {
  type        = bool
  description = "Flag to define if development on the ABAP system is allowed."
  default     = true
}

variable "custom_idp" {
  type        = string
  description = "Name of custom IDP to be used for the subaccount"
}

variable "origin" {
  type        = string
  description = "The identity provider for the UAA user."
  default     = "sap.ids"
}

variable "create_tfvars_file_for_next_stage" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for the next step."
  default     = false
}
