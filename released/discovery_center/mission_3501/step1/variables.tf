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
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the Subaccount Admins."
  }
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_service_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_service_admins)
    error_message = "Please enter a valid email address for the Subaccount service Admins."
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
  default     = "standard-edition"
  validation {
    condition     = contains(["standard-edition"], var.service_plan__sap_business_app_studio)
    error_message = "Invalid value for service_plan__sap_business_app_studio. Only 'standard-edition' is allowed."
  }
}

variable "appstudio_developers" {
  type        = list(string)
  description = "Business Application Studio Developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Business Application Studio Developers contains a list of valid email addresses
  validation {
    condition     = length([for email in var.appstudio_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.appstudio_developers)
    error_message = "Please enter a valid email address for the Business Application Studio Developers"
  }
}

variable "appstudio_admins" {
  type        = list(string)
  description = "Business Application Studio Administrators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Business Application Studio Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.appstudio_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.appstudio_admins)
    error_message = "Please enter a valid email address for the Business Application Studio Administrators."
  }
}

variable "hana_cloud_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added as admins to access the instance of SAP HANA Cloud."
  default     = ["jane.doe@test.com", "john.doe@test.com"]

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.hana_cloud_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.hana_cloud_admins)
    error_message = "Please enter a valid email address for the admins of SAP HANA Cloud instance."
  }
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
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.event_mesh_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.event_mesh_admins)
    error_message = "Please enter a valid email address for the Enterprise Messaging Administrators."
  }
}

variable "event_mesh_developers" {
  type        = list(string)
  description = "Enterprise Messaging Developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Enterprise Messaging Developers contains a list of valid email addresses
  validation {
    condition     = length([for email in var.event_mesh_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.event_mesh_developers)
    error_message = "Please enter a valid email address for the Enterprise Messaging Developers."
  }
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
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Workzone Standard Edition Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.workzone_se_administrators : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.workzone_se_administrators)
    error_message = "Please enter a valid email address for the Workzone Standard Edition Administratorss."
  }
}

variable "tms_admins" {
  type        = list(string)
  description = "TMS Administrators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if TMS Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.tms_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.tms_admins)
    error_message = "Please enter a valid email address for the TMS Administrators."
  }
}

variable "tms_import_operators" {
  type        = list(string)
  description = "TMS Import Operators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if TMS Import Operators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.tms_import_operators : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.tms_import_operators)
    error_message = "Please enter a valid email address for the TMS Import Operators."
  }
}

variable "cicd_service_admins" {
  type        = list(string)
  description = "CICD Service Administrators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if CICD Service Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cicd_service_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cicd_service_admins)
    error_message = "Please enter a valid email address for the CICD Service Administrators."
  }
}

# ------------------------------------------------------------------------------------------------------
# Switch for creating tfvars for step 2
# ------------------------------------------------------------------------------------------------------
variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = true
}


