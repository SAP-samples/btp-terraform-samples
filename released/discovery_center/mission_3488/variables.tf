variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Discovery Center mission subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "eu11"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = ""
}

variable "sac_first_name" {
  type        = string
  description = "The first name of the QAS SAP Analytics Cloud user."
}

variable "sac_last_name" {
  type        = string
  description = "The last name of the QAS SAP Analytics Cloud user."
}

variable "sac_email" {
  type        = string
  description = "The email of the QAS SAP Analytics Cloud user."
}

variable "sac_host_name" {
  type        = string
  description = "The host name for the SAP Analytics Cloud service instance."
}
