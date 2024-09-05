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

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = ""
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__sap_process_automation" {
  type        = string
  description = "The plan for service 'SAP Build Process Automation' with technical name 'process-automation'"
  default     = "free"

  validation {
    condition     = contains(["standard", "free"], var.service_plan__sap_process_automation)
    error_message = "Invalid value for service_plan__sap_process_automation. Only 'standard' and 'free' are allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the users who are added to subaccount as administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the users who are added to subaccount as service administrators."
}

variable "process_automation_admins" {
  type        = list(string)
  description = "Defines the users who have the role of 'ProcessAutomationAdmin' in SAP Build Process Automation."
}

variable "process_automation_developers" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationDeveloper in SAP Build Process Automation"
}

variable "process_automation_participants" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationParticipant in SAP Build Process Automation"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}
