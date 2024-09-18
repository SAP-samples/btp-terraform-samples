# ------------------------------------------------------------------------------------------------------
# Account variables
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission trial subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The ID of the trial subaccount."
  default     = ""
}
# ------------------------------------------------------------------------------------------------------
# use case specific variables
# ------------------------------------------------------------------------------------------------------
variable "abap_admin_email" {
  type        = string
  description = "Email of the ABAP Administrator."
  default     = ""
}

variable "create_cf_space" {
  type        = bool
  description = "Determines whether a new CF space should be created. Must be true if no space with the given name exists for the org, false otherwise. If CF isn't enabled for no subaccount a new space will always be created"
  default     = false
}

variable "cf_space_name" {
  type        = string
  description = "The name of the CF space to use."
  default     = "dev"
}

# ------------------------------------------------------------------------------------------------------
# service plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__abap_trial" {
  type        = string
  description = "The plan for service 'ABAP environment' with technical name 'abap-trial'"
  default     = "shared"
  validation {
    condition     = contains(["shared"], var.service_plan__abap_trial)
    error_message = "Invalid value for service_plan__abap_trial. Only 'shared' is allowed."
  }
}

variable "service_plan__cloudfoundry" {
  type        = string
  description = "The plan for service 'Destination Service' with technical name 'destination'"
  default     = "trial"
  validation {
    condition     = contains(["trial"], var.service_plan__cloudfoundry)
    error_message = "Invalid value for service_plan__cloudfoundry. Only 'trial' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "cf_org_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry org."
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

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}