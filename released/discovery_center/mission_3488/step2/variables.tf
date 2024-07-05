variable "cf_api_url" {
  type        = string
  description = "The API endpoint of the Cloud Foundry environment."
}

variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry landscape (format example eu10-004)."
}

variable "origin" {
  type        = string
  description = "The identity provider for the UAA user."
  default     = "sap.ids"
}

variable "cf_org_admins" {
  type        = list(string)
  description = "List of users to set as Cloudfoundry org administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the CF Org admins."
  }
}


variable "cf_org_billing_managers" {
  type        = list(string)
  description = "List of Cloud Foundry org billing managers."
  default     = []

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_billing_managers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_billing_managers)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "cf_org_auditors" {
  type        = list(string)
  description = "List of Cloud Foundry org auditors."
  default     = []

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_auditors : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_auditors)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "cf_space_managers" {
  type        = list(string)
  description = "List of managers for the Cloud Foundry space."
  default     = []

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_managers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_managers)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "cf_space_developers" {
  type        = list(string)
  description = "List of developers for the Cloud Foundry space."
  default     = []

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_developers : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_developers)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "The list of Cloud Foundry space auditors."
  default     = []

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_auditors : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_auditors)
    error_message = "Please enter a valid email address for the subaccount admins."
  }
}

variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}


variable "service_plan__sac" {
  type        = string
  description = "Plan for the service instance of ABAP."
  default     = "free"
}

variable "sac_param_first_name" {
  type        = string
  description = "First name of the SAC responsible"
}

variable "sac_param_last_name" {
  type        = string
  description = "Last name of the SAC responsible"
}

variable "sac_param_email" {
  type        = string
  description = "Email of the SAC responsible"

  validation {
    condition     = can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", var.sac_param_email))
    error_message = "Please enter a valid email address for the SAC responsible."
  }
}

variable "sac_param_host_name" {
  type        = string
  description = "Host name of the SAC"
  validation {
    condition     = can(regex("^[a-zA-Z0-9]", var.sac_param_host_name))
    error_message = "Please enter a valid host name. Should only contain letters and numbers."
  }
}


variable "sac_param_number_of_business_intelligence_licenses" {
  type        = number
  description = "Number of business intelligence licenses"
  default     = 6
}


variable "sac_param_number_of_professional_licenses" {
  type        = number
  description = "Number of business professional licenses"
  default     = 1
}

variable "sac_param_number_of_business_standard_licenses" {
  type        = number
  description = "Number of business standard licenses"
  default     = 2
}
