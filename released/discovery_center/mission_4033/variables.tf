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
  default     = "DC Mission 4033 - Create simple, connected digital experiences with API-based integration"
}

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
  description = "Defines the colleagues who are added to each subaccount as Subaccount administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as Subaccount service administrators."
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as Subaccount service administrators."
}

variable "service_plan__sap_build_apps" {
  type        = string
  description = "The plan for SAP Build Apps subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard", "partner"], var.service_plan__sap_build_apps)
    error_message = "Invalid value for service_plan__sap_build_apps. Only 'free', 'standard' and 'partner' are allowed."
  }
}

variable "service_plan__sap_process_automation" {
  type        = string
  description = "The plan for SAP Build Process Automation"
  default     = "standard"
  validation {
    condition     = contains(["standard", "advanced-user"], var.service_plan__sap_process_automation)
    error_message = "Invalid value for service_plan__sap_process_automation. Only 'standard' and 'advanced-user' are allowed."
  }
}

variable "service_plan__sap_integration_suite" {
  type        = string
  description = "The plan for SAP Integration Suite"
  default     = "enterprise_agreement"
  validation {
    condition     = contains(["enterprise_agreement"], var.service_plan__sap_integration_suite)
    error_message = "Invalid value for service_plan__sap_integration_suite. Only 'enterprise_agreement' are allowed."
  }
}

###
# Entitlements
###
variable "entitlements" {
  type = list(object({
    service_name = string
    plan_name    = string
    type         = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = [
    {
      service_name = "destination"
      plan_name    = "lite",
      type         = "service"
    },
    {
      service_name = "xsuaa"
      plan_name    = "application",
      type         = "service"
    },
    {
      service_name = "process-automation-service"
      plan_name    = "standard",
      type         = "service"
    },
    {
      service_name = "apimanagement-apiportal"
      plan_name    = "apiportal-apiaccess",
      type         = "service"
    },
    {
      service_name = "apimanagement-devportal"
      plan_name    = "devportal-apiaccess",
      type         = "service"
    }
  ]
}

variable "kyma_instance" { type = object({
  name            = string
  region          = string
  machine_type    = string
  auto_scaler_min = number
  auto_scaler_max = number
  createtimeout   = string
  updatetimeout   = string
  deletetimeout   = string
}) }

variable "conn_dest_admin" {
  type        = list(string)
  description = "Connectivity and Destination Administrator"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "int_provisioner" {
  type        = list(string)
  description = "Integration Provisioner"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = "terraformint"

  validation {
    condition     = can(regex("^[a-z-]", var.custom_idp))
    error_message = "Please enter a valid entry for the custom-idp of the subaccount."
  }
}

variable "users_BuildAppsAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsAdmin' in SAP Build Apps."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "users_BuildAppsDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsDeveloper' in SAP Build Apps."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "users_RegistryAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'RegistryAdmin' in SAP Build Apps."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "users_RegistryDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of RegistryDeveloper' in SAP Build Apps."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "ProcessAutomationAdmin" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationAdmin in SAP Build Process Automation"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "ProcessAutomationDeveloper" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationDeveloper in SAP Build Process Automation"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "ProcessAutomationParticipant" {
  type        = list(string)
  description = "Defines the users who have the role of ProcessAutomationParticipant in SAP Build Process Automation"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}