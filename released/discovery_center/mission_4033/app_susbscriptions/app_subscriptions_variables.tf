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
}

variable kyma_instance { type = object({
  name            = string
  region          = string
  machine_type    = string
  auto_scaler_min = number
  auto_scaler_max = number
  createtimeout   = string
  updatetimeout   = string
  deletetimeout   = string
})}

variable "conn_dest_admin" {
  type        = list(string)
  description = "Connectivity and Destination Administrator"
}

variable "int_provisioner" {
  type        = list(string)
  description = "Integration Provisioner"
}

variable "custom_idp_origin" {
  type        = string
  description = "Defines the custom IDP origin to be used for the subaccount"
}

variable "users_BuildAppsAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsAdmin' in SAP Build Apps."
}

variable "users_BuildAppsDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'BuildAppsDeveloper' in SAP Build Apps."
}

variable "users_RegistryAdmin" {
  type        = list(string)
  description = "Defines the colleagues who have the role of 'RegistryAdmin' in SAP Build Apps."
}

variable "users_RegistryDeveloper" {
  type        = list(string)
  description = "Defines the colleagues who have the role of RegistryDeveloper' in SAP Build Apps."
}

variable "ProcessAutomationAdmin" {
  type    = list(string)
  description = "Defines the users who have the role of ProcessAutomationAdmin in SAP Build Process Automation"
}

variable "ProcessAutomationDeveloper" {
  type    = list(string)
  description = "Defines the users who have the role of ProcessAutomationDeveloper in SAP Build Process Automation"
}

variable "ProcessAutomationParticipant" {
  type    = list(string)
  description = "Defines the users who have the role of ProcessAutomationParticipant in SAP Build Process Automation"
}

variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
}

variable "btp_subaccount_id" {
  type        = string
  description = "SAP BTP Subaccount ID"
}

variable "subdomain" {
  type        = string
  description = "SAP BTP Subdomain"
}