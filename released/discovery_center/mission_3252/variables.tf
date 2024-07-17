######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
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
  default     = "cf-eu10"
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
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
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
  default = {
    name            = "my-kyma-environment"
    region          = "eu-central-1"
    machine_type    = "mx5.xlarge"
    auto_scaler_min = 3
    auto_scaler_max = 20
    createtimeout   = "1h"
    updatetimeout   = "35m"
    deletetimeout   = "1h"
  }
}