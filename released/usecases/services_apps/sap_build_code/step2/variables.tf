# The CF Org ID from the Cloud Foundry environment instance
variable "cf_org_id" {
  type        = string
  description = "The Cloud Foundry Org ID from the Cloud Foundry environment instance."
}  

variable "cf_api_endpoint" {
  type        = string
  description = "The Cloud Foundry API endpoint from the Cloud Foundry environment instance."
}

variable "cf_org_name" {
  type        = string
  description = "The Cloud Foundry Org name from the Cloud Foundry environment instance."
 
}

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
