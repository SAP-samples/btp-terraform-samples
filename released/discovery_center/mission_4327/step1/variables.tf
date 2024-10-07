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
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = ""
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# user lists
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to subaccount as administrator"
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to subaccount as service administrator"
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}

# ------------------------------------------------------------------------------------------------------
# use case specific variables
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# ENVIRONMENTS (plans, user lists and other vars)
# ------------------------------------------------------------------------------------------------------
# cloudfoundry (Cloud Foundry Environment)
# ------------------------------------------------------------------------------------------------------
# plans
variable "service_env_plan__cloudfoundry" {
  type        = string
  description = "The plan for service environment 'Cloud Foundry Environment' with technical name 'cloudfoundry'"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.service_env_plan__cloudfoundry)
    error_message = "Invalid value for service_env_plan__cloudfoundry. Only 'free' and 'standard' are allowed."
  }
}

# user lists
variable "cf_org_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry org."
}

variable "cf_org_users" {
  type        = list(string)
  description = "List of users for the Cloud Foundry org."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
}

# cf landscape, org, space variables
variable "cf_landscape_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = ""
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

# ------------------------------------------------------------------------------------------------------
# SERVICES (plans and other parameters)
# ------------------------------------------------------------------------------------------------------
# hana-cloud (SAP HANA Cloud)
# ------------------------------------------------------------------------------------------------------
# plans
variable "service_plan__hana_cloud" {
  type        = string
  description = "The plan for service 'SAP HANA Cloud' with technical name 'hana-cloud'"
  default     = "hana-free"
  validation {
    condition     = contains(["hana-free"], var.service_plan__hana_cloud)
    error_message = "Invalid value for service_plan__hana_cloud. Only 'free' is allowed."
  }
}

# testing
variable "enable_service_setup__hana_cloud" {
  type        = bool
  description = "If true setup of service 'SAP HANA Cloud' with technical name 'hana-cloud' is enabled"
  default     = true
}
# ------------------------------------------------------------------------------------------------------
# hana (SAP HANA Schemas & HDI Containers)
# ------------------------------------------------------------------------------------------------------
# plans
variable "service_plan__hana" {
  type        = string
  description = "The plan for service 'SAP HANA Schemas & HDI Containers' with technical name 'hana'"
  default     = "hdi-shared"
  validation {
    condition     = contains(["hdi-shared"], var.service_plan__hana)
    error_message = "Invalid value for service_plan__hana. Only 'hdi-shared' is allowed."
  }
}

# testing
variable "enable_service_setup__hana" {
  type        = bool
  description = "If true setup of service 'SAP HANA Schemas & HDI Containers' with technical name 'hana' is enabled"
  default     = true
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS (plans and user lists)
# ------------------------------------------------------------------------------------------------------
# SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# plans
variable "app_subscription_plan__sap_launchpad" {
  type        = string
  description = "The plan for app subscription 'SAP Build Work Zone, standard edition' with technical name 'SAPLaunchpad'"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.app_subscription_plan__sap_launchpad)
    error_message = "Invalid value for app_subscription_plan__sap_launchpad. Only 'free' and 'standard' are allowed."
  }
}

# user lists
variable "launchpad_admins" {
  type        = list(string)
  description = "Defines the colleagues who are Launchpad Admins."
}

# testing
variable "enable_app_subscription_setup__sap_launchpad" {
  type        = bool
  description = "If true setup of app subscription 'SAP Build Work Zone, standard edition' with technical name 'SAPLaunchpad' is enabled"
  default     = true
}

# ------------------------------------------------------------------------------------------------------
# hana-cloud-tools (SAP HANA Cloud)
# ------------------------------------------------------------------------------------------------------
# plans
variable "app_subscription_plan__hana_cloud_tools" {
  type        = string
  description = "The plan for app subscription 'SAP HANA Cloud' with technical name 'hana-cloud-tools'"
  default     = "tools"
  validation {
    condition     = contains(["tools"], var.app_subscription_plan__hana_cloud_tools)
    error_message = "Invalid value for app_subscription_plan__hana_cloud_tools. Only 'tools' is allowed."
  }
}

# user lists
variable "hana_cloud_admins" {
  type        = list(string)
  description = "Defines the colleagues who are HANA Cloud Admins."
}

# testing
variable "enable_app_subscription_setup__hana_cloud_tools" {
  type        = bool
  description = "If true setup of app subscription 'SAP HANA Cloud' with technical name 'hana-cloud-tools' is enabled"
  default     = true
}

# ------------------------------------------------------------------------------------------------------
# cicd-app (Continuous Integration & Delivery)
# ------------------------------------------------------------------------------------------------------
# plans
variable "app_subscription_plan__cicd_app" {
  type        = string
  description = "The plan for app subscription 'Continuous Integration & Delivery' with technical name 'cicd-app'"
  default     = "free"
  validation {
    condition     = contains(["free", "default"], var.app_subscription_plan__cicd_app)
    error_message = "Invalid value for app_subscription_plan__cicd_app. Only 'free' and 'default' are allowed."
  }
}

# testing
variable "enable_app_subscription_setup__cicd_app" {
  type        = bool
  description = "If true setup of app subscription 'Continuous Integration & Delivery' with technical name 'cicd-app' is enabled"
  default     = true
}