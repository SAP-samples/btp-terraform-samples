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
  default     = "https://cli.btp.cloud.sap"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as Subaccount administrators."
}

variable "subaccount_service_admins" {
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
}

variable "service_plan__sap_process_automation_service" {
  type        = string
  description = "The plan for SAP Build Process Automation Service"
  default     = "standard"
}


variable "service_plan__sap_integration_suite" {
  type        = string
  description = "The plan for SAP Integration Suite"
  default     = "enterprise_agreement"
  validation {
    condition     = contains(["enterprise_agreement", "free"], var.service_plan__sap_integration_suite)
    error_message = "Invalid value for service_plan__sap_integration_suite. Only 'enterprise_agreement' and 'free' are allowed."
  }
}

variable "service_plan__apimanagement_apiportal" {
  type        = string
  description = "The plan for SAP Build Process Automation"
  default     = "apiportal-apiaccess"
}

variable "service_plan__apimanagement_devportal" {
  type        = string
  description = "The plan for SAP Build Process Automation"
  default     = "devportal-apiaccess"
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

variable "int_provisioners" {
  type        = list(string)
  description = "Integration Provisioner"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
}

variable "users_buildApps_admins" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsAdmin' in SAP Build Apps."
}

variable "users_buildApps_developers" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsDeveloper' in SAP Build Apps."
}

variable "users_registry_admins" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'RegistryAdmin' in SAP Build Apps."
}

variable "users_registry_developers" {
  type        = list(string)
  description = "Defines the colleagues who have the role of RegistryDeveloper' in SAP Build Apps."
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
}

variable "service_plan__sap_identity_services_onboarding" {
  type        = string
  description = "The plan for service 'Cloud Identity Services' with technical name 'sap-identity-services-onboarding'"
  default     = "default"
  validation {
    condition     = contains(["default"], var.service_plan__sap_identity_services_onboarding)
    error_message = "Invalid value for service_plan__sap_identity_services_onboarding. Only 'default' is allowed."
  }
}

variable "custom_idp_apps_origin_key" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.custom"
}

variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = true
}