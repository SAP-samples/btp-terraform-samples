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
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

variable "cf_org_id" {
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

variable "origin" {
  type        = string
  description = "Defines the origin of the identity provider"
  default     = "sap.ids"
  # The value for the origin can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "subaccount_id" {
  type = string
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}
