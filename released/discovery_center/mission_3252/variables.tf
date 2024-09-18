# ------------------------------------------------------------------------------------------------------
# Account variables
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "custom_idp" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = ""
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "eu10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# service parameters
# ------------------------------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the users who are added to subaccount as administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the users who are added to subaccount as service administrators."
}