
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default = "terraformint"

  validation {
    condition = can(regex("^[a-z-]", var.custom_idp))
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

variable "entitlements" {
  description = "List of entitlements for a BTP subaccount"
    type = list(object({
      name = string
      plan = string
      type = string
  }))

  default = [
    {
      name = "SAPLaunchpad"
      plan = "free"
      type = "subscription"
    },
    {
      name = "sap-build-apps"
      plan = "standard"
      type = "subscription"
    }
  ]
}
