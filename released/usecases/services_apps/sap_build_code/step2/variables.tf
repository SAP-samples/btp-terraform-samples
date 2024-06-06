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

# The admins of the CF Org
variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each cf org."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.admins)
    error_message = "Please enter a valid email address for the admins."
  }
}

# Define roles for a CF user
variable "roles_cf_org" {
  type        = list(string)
  description = "Defines the list of roles to be assigned to the users in a CF Org."
  default = [
    "organization_user",
    "organization_manager",
    "organization_auditor",
    "organization_billing_manager"
  ]
}

# Define roles for a user in the CF space
variable "roles_cf_space" {
  type        = list(string)
  description = "Defines the list of roles to be assigned to the users in a CF Org."
  default = [
    "space_developer",
    "space_supporter",
    "space_manager",
    "space_auditor"
  ]
}

# The identity provider for the subaccount
variable "identity_provider" {
  type        = string
  description = "The identity provider for the subaccount."
  default     = "sap.default"
}