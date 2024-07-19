variable "globalaccount" {
  type        = string
  description = "The subdomain of the trial account."
}

variable "subaccount_id" {
  type        = string
  description = "The ID of the trial subaccount."
  default     = ""
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "cf_org_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry org."
  default     = []
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
}

variable "cf_space_name" {
  type        = string
  description = "The name of the CF space to use."
}

variable "create_cf_space" {
  type        = bool
  description = "Determines whether a new CF space should be created. Must be true if no space with the given name exists for the org, false otherwise. If CF isn't enabled for the subaccount a new space will always be created"
  default     = false
}

variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrator."
  default     = ""
}

variable "create_tfvars_file_for_next_stage" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for the next step."
  default     = false
}
