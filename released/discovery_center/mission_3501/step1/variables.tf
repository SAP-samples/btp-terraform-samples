######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
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

variable "service_plan__sap_business_app_studio" {
  type        = string
  description = "The plan for SAP Business Application Studio"
  default     = "standard-edition"
  validation {
    condition     = contains(["standard-edition"], var.service_plan__sap_business_app_studio)
    error_message = "Invalid value for service_plan__sap_business_app_studio. Only 'standard-edition' is allowed."
  }
}

###
# Entitlements
###
variable "entitlements" {
  type = list(object({
    service_name = string
    plan_name    = string
    type         = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = [
    {
      service_name = "connectivity"
      plan_name    = "lite",
      type         = "service"
    },
    {
      service_name = "destination"
      plan_name    = "lite",
      type         = "service"
    },
    {
      service_name = "html5-apps-repo"
      plan_name    = "app-host",
      type         = "service"
    },
    {
      service_name = "xsuaa"
      plan_name    = "application",
      type         = "service"
    }
  ]
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

variable "cloudconnector_admins" {
  type        = list(string)
  description = "Cloud Connector Administrators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Cloud Connector Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cloudconnector_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cloudconnector_admins)
    error_message = "Please enter a valid email address for the Cloud Connector Administrators."
  }
}

variable "conn_dest_admins" {
  type        = list(string)
  description = "Connectivity and Destination Administrators"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
  # add validation to check if Connectivity and Destination Administrators contains a list of valid email addresses
  validation {
    condition     = length([for email in var.conn_dest_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.conn_dest_admins)
    error_message = "Please enter a valid email address for the Connectivity and Destination Administrators."
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


