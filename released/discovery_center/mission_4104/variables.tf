variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us20"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.ids"
}

variable "datasphere_first_name" {
  type        = string
  description = "The first name of the datasphere user."
}

variable "datasphere_last_name" {
  type        = string
  description = "The last name of the datasphere user."
}

variable "datasphere_email" {
  type        = string
  description = "The email of the datasphere user."

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.datasphere_email))
    error_message = "Please enter a valid email address for the Datasphere user."
  }
}

variable "datasphere_host_name" {
  type        = string
  description = "The host name for the SAP Datasphere service instance. The host name of the tenant can only contain numbers (0-9), lower case letters (a-z), and hyphens (-). The same host name can't be reused to create other instances."
  default     = ""

  validation {
    condition     = length(var.datasphere_host_name) <= 100 && can(regex("^[a-z0-9-]*$", var.datasphere_host_name))
    error_message = "Please include only lower case letters, numbers and hyphens. White spaces are not allowed."
  }
}
