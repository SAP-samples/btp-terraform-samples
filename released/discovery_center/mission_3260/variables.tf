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

# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
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

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.process_automation_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.process_automation_admins)
    error_message = "Please enter a valid email address for the Process Automation Admins."
  }
}

variable "process_automation_developers" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationDeveloper in SAP Build Process Automation"

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.process_automation_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.process_automation_developers)
    error_message = "Please enter a valid email address for the Process Automation Developers."
  }
}

variable "process_automation_participants" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationParticipant in SAP Build Process Automation"
  default     = ["jane.doe@test.com", "john.doe@test.com"]

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.process_automation_participants : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.process_automation_participants)
    error_message = "Please enter a valid email address for the Process Automation Participants."
  }
}