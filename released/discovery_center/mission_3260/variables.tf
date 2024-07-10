######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "DC Mission 3260 - Process and approve your invoices with SAP Build Process Automation"
}

# subaccount id
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

variable "cli_server_url" {
  type        = string
  description = "Defines the CLI server URL"
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
}

# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}


# Process automation Variables
variable "service_plan__sap_process_automation" {
  type        = string
  description = "The plan for SAP Build Process Automation"
  default     = "standard"

  validation {
    condition     = contains(["standard", "free"], var.service_plan__sap_process_automation)
    error_message = "Invalid value for service_plan__sap_process_automation. Only 'standard' and 'free' are allowed."
  }
}

variable "process_automation_admins" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationAdmin in SAP Build Process Automation"
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
