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
  default     = "DC Mission 4038 -  SAP Ariba Procurement Operations"
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
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
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

# service plan datasphere
variable "service_plan__sap_datasphere" {
  type        = string
  description = "The service plan for the SAP Datasphere."
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.service_plan__sap_datasphere)
    error_message = "Invalid value for service_plan__sap_datasphere. Only 'free' & 'standard' are allowed."
  }
}

# Integration Suite
variable "service_plan__sap_integration_suite" {
  type        = string
  description = "The plan for SAP Integration Suite"
  default     = "enterprise_agreement"
  validation {
    condition     = contains(["free", "enterprise_agreement"], var.service_plan__sap_integration_suite)
    error_message = "Invalid value for service_plan__sap_integration_suite. Only 'free' and 'enterprise_agreement' are allowed."
  }
}

variable "int_provisioners" {
  type        = list(string)
  description = "Integration Provisioners"
}

# Datasphere User Info

# first name
variable "datasphere_admin_first_name" {
  type        = string
  description = "Datasphere Admin First Name"
  default     = "first name"
}

# last name
variable "datasphere_admin_last_name" {
  type        = string
  description = "Datasphere Admin Last Name"
  default     = "last name"
}

# email
variable "datasphere_admin_email" {
  type        = string
  description = "Datasphere Admin Email"
}

# host_name
variable "datasphere_admin_host_name" {
  type        = string
  description = "Datasphere Admin Host Name"
  default     = ""
}
