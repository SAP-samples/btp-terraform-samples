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

variable "custom_idp_apps_origin_key" {
  type        = string
  description = "The custom identity provider for the subaccount."
  default     = "sap.custom"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Code subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# cf related variables
# ------------------------------------------------------------------------------------------------------
variable "origin" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = "sap.ids"
  # The value for the origin_key can be defined
  # but are normally set to "sap.ids", "sap.default" or "sap.custom"
}

variable "origin_key" {
  type        = string
  description = "Defines the origin key of the identity provider"
  default     = ""
  # The value for the origin_key can be defined, set to "sap.ids", "sap.default" or "sap.custom"
}

variable "cf_landscape_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = "mission-4441-sap-build-code"

  validation {
    condition     = can(regex("^.{1,255}$", var.cf_org_name))
    error_message = "The Cloud Foundry org name must not be emtpy and not exceed 255 characters."
  }
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

/*
# hana password
variable "hana_cloud_system_password" {
  type        = string
  description = "The system password for the hana_cloud service instance."
  default     = "Abcd1234"
}
*/

# ------------------------------------------------------------------------------------------------------
# services plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__cloudfoundry" {
  type        = string
  description = "The plan for service 'Destination Service' with technical name 'destination'"
  default     = "standard"
  validation {
    condition     = contains(["standard"], var.service_plan__cloudfoundry)
    error_message = "Invalid value for service_plan__cloudfoundry. Only 'standard' is allowed."
  }
}

variable "service_plan__connectivity" {
  type        = string
  description = "The plan for service 'Connectivity Service' with technical name 'connectivity'"
  default     = "lite"
}

variable "service_plan__destination" {
  type        = string
  description = "The plan for service 'Destination Service' with technical name 'destination'"
  default     = "lite"
}

variable "service_plan__html5_apps_repo" {
  type        = string
  description = "The plan for service 'HTML5 Application Repository Service' with technical name 'html5-apps-repo'"
  default     = "app-host"
}

variable "service_plan__xsuaa" {
  type        = string
  description = "The plan for service 'Authorization and Trust Management Service' with technical name 'xsuaa'"
  default     = "application"
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__integrationsuite" {
  type        = string
  description = "The plan for service 'Integration Suite' with technical name 'integrationsuite'"
  default     = "enterprise_agreement"
  validation {
    condition     = contains(["enterprise_agreement", "free"], var.service_plan__integrationsuite)
    error_message = "Invalid value for service_plan__integrationsuite. Only 'enterprise_agreement' and 'free' are allowed."
  }
}

variable "service_plan__sapappstudio" {
  type        = string
  description = "The plan for service 'SAP Business Application Studio' with technical name 'sapappstudio'"
  default     = "standard-edition"
  validation {
    condition     = contains(["standard-edition"], var.service_plan__sapappstudio)
    error_message = "Invalid value for service_plan__sapappstudio. Only 'standard-edition' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to subaccount as administrator"
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to subaccount as service administrator"
}

variable "integration_provisioners" {
  type        = list(string)
  description = "Integration Provisioner"
}

variable "sapappstudio_admins" {
  type        = list(string)
  description = "Defines the colleagues who are administrators for SAP Business Application Studio."
}

variable "sapappstudio_developers" {
  type        = list(string)
  description = "Defines the colleagues who are developers for SAP Business Application Studio."
}

variable "cloud_connector_admins" {
  type        = list(string)
  description = "Defines the colleagues who are administrators for Cloud Connector"
}

variable "connectivity_destination_admins" {
  type        = list(string)
  description = "Defines the colleagues who are administrators for Connectivity and Destinations"
}

variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a Cloudfoundry as org administrators."
}

variable "cf_org_users" {
  type        = list(string)
  description = "Defines the colleagues who are added to a Cloudfoundry as org users."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = true
}