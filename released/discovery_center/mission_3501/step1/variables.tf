######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "UC - Deliver Connected Experiences with a single view of Material Availability"
}

# cf org name
variable "cf_org_name" {
  type        = string
  description = "Cloud Foundry Org Name"
  default     = "cloud-foundry"
}

# cf landscape label
variable "cf_landscape_label" {
  type        = string
  description = "The Cloud Foundry landscape (format example eu10-004)."
  default     = ""
}

# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

# CLI server
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

# subaccount variables
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
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

variable "cf_org_admins" {
  type        = list(string)
  description = "List of users to set as Cloudfoundry org administrators."
}

variable "cf_org_users" {
  type        = list(string)
  description = "List of users to set as Cloudfoundry org users."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."
}



variable "service_plan__sap_business_app_studio" {
  type        = string
  description = "The plan for SAP Business Application Studio"
}

variable "appstudio_developers" {
  type        = list(string)
  description = "Business Application Studio Developers"
}

variable "appstudio_admins" {
  type        = list(string)
  description = "Business Application Studio Administrators"
}

variable "hana_cloud_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added as admins to access the instance of SAP HANA Cloud."
}


variable "hana_system_password" {
  type        = string
  description = "The password of the database 'superuser' DBADMIN."
  sensitive   = true

  # add validation to check if the password is at least 8 characters long
  validation {
    condition     = length(var.hana_system_password) > 7
    error_message = "The hana_system_password must be at least 8 characters long."
  }

  # add validation to check if the password contains at least one upper case
  validation {
    condition     = can(regex("[A-Z]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one upper case."
  }

  # add validation to check if the password contains at least two lower case characters that can occur on arbitrary places in the string (not necessarily in a row)
  validation {
    condition     = length(regexall("[a-z]", var.hana_system_password)) > 1
    error_message = "The hana_system_password must contain at least two lower case characters."
  }

  # add validation to check if the password contains at least one numeric character
  validation {
    condition     = can(regex("[0-9]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one numeric character."
  }
}


variable "event_mesh_admins" {
  type        = list(string)
  description = "Enterprise Messaging Administrators"
}

variable "event_mesh_developers" {
  type        = list(string)
  description = "Enterprise Messaging Developers"
}

variable "service_plan__build_workzone" {
  type        = string
  description = "The plan for build_workzone subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.service_plan__build_workzone)
    error_message = "Invalid value for service_plan__build_workzone. Only 'free' and 'standard' are allowed."
  }
}

variable "workzone_se_administrators" {
  type        = list(string)
  description = "Workzone Standard Edition Administrators"
}

variable "tms_admins" {
  type        = list(string)
  description = "TMS Administrators"
}

variable "tms_import_operators" {
  type        = list(string)
  description = "TMS Import Operators"
}

variable "cicd_service_admins" {
  type        = list(string)
  description = "CICD Service Administrators"
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = true
}


