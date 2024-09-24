variable "globalaccount" {
  type        = string
  description = "Defines the global account"
  default     = "yourglobalaccount"
}

variable "cli_server_url" {
  type        = string
  description = "Defines the CLI server URL"
  default     = "https://cli.btp.cloud.sap"
}

variable "cf_api_url" {
  type = string
}

variable "cf_org_id" {
  type = string
}

variable "subaccount_id" {
  type = string
}

variable "cf_space_name" {
  type        = string
  description = "Name of the Cloud Foundry space."
  default     = "dev"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_space_name))
    error_message = "The Cloud Foundry space name must not be emtpy and not exceed 255 characters."
  }
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
}


variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
}