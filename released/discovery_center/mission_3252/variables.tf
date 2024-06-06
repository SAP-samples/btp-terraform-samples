######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "your globalaccount subdomain"
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "DC Mission 3252 - Get Started with SAP BTP, Kyma runtime creating a Hello-World Function"
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "eu30"
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
      service_name = "integrationsuite"
      plan_name    = "enterprise_agreement",
      type         = "app"
    },
    {
      service_name = "sap-build-apps"
      plan_name    = "standard"
      type         = "service"
    },
    {
      service_name = "process-automation"
      plan_name    = "standard",
      type         = "app"
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

variable "kyma_instance" { 
    type = object({
    name            = string
    region          = string
    machine_type    = string
    auto_scaler_min = number
    auto_scaler_max = number
    createtimeout   = string
    updatetimeout   = string
    deletetimeout   = string
  }) 
  description = "Your Kyma environment configuration"
}

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