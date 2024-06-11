# Description: This file contains the input variables for the SAP Build Code step 2.check 

# The globalaccount subdomain where the sub account shall be created.
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

# The subaccount id
variable "subaccount_id" {
  type        = string
  description = "The subaccount id."
}

# The BTP CLI server URL
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.sap.hana.ondemand.com"
}

# The CF Org ID from the Cloud Foundry environment instance
variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
}

# The CF API endpoint from the Cloud Foundry environment instance
variable "cf_api_endpoint" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

# The CF Org name from the Cloud Foundry environment instance
variable "cf_org_name" {
  type        = string
  description = "The Cloud Foundry Org name from the Cloud Foundry environment instance."

}

variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF org as administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_org_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_org_admins)
    error_message = "Please enter a valid email address for the CF Org admins."
  }
}

variable "cf_space_manager" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space manager."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_manager : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_manager)
    error_message = "Please enter a valid email address for the CF space managers."
  }
}

variable "cf_space_developer" {
  type        = list(string)
  description = "Defines the colleagues who are added to a CF space as space developer."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.cf_space_developer : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.cf_space_developer)
    error_message = "Please enter a valid email address for the admins."
  }
}


# The identity provider for the subaccount
variable "identity_provider" {
  type        = string
  description = "The identity provider for the subaccount."
  default     = "sap.ids"
}
