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
  default     = "eu10"
}

# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount."
  default     = ""
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
}

variable "kyma_instance_parameters" {
  type = object({
    name            = string
    region          = string
    machine_type    = string
    auto_scaler_min = number
    auto_scaler_max = number
  })
  description = "Your Kyma environment configuration parameters. Name and region are mandatory. Please refer to the following documentation for more details: https://help.sap.com/docs/btp/sap-business-technology-platform/provisioning-and-update-parameters-in-kyma-environment."
  default     = null

  validation {
    condition = (
      var.kyma_instance_parameters == null ? true : length(var.kyma_instance_parameters.name) > 0 && length(var.kyma_instance_parameters.region) > 0
    )

    error_message = "Value for kyma_instance_parameters must either be null or an object with values for at least name and region"
  }
}

variable "kyma_instance_timeouts" {
  type = object({
    create = string
    update = string
    delete = string
  })
  description = "Timeouts for the creation, update, and deletion of the Kyma instance."
  default = {
    create = "1h"
    update = "35m"
    delete = "1h"
  }
}