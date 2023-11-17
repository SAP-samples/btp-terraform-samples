variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
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

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
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

### Azure parameters
variable "azure_rg_name" {
  description = "The name of the resource group in Azure"
  type        = string
}

variable "azure_location" {
  description = "The location of the resource group in Azure"
  type        = string
}

variable "azure_storage_account_name" {
  description = "The name of the storage account in Azure"
  type        = string

}

variable "azure_container_name" {
  description = "The name of the storage container in Azure"
  type        = string
}
