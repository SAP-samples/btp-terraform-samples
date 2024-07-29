variable "global_account" {
  description = "Global account where the subaccount shall be created in."
  type        = string
}

variable "region" {
  type        = string
  description = "Region where the subaccount will be running."
}

variable "project_name" {
  type        = string
  description = "Name of the project."
}

variable "subaccounts" {
  type = map(object({
    labels = optional(map(set(string)), null)
    entitlements = list(object({
      type   = string
      name   = string
      plan   = string
      amount = number
    }))
    subscriptions = list(object({
      app  = string
      plan = string
    }))
    role_collection_assignments = list(object({
      role_collection_name = string
      users                = set(string)
    }))
    cf_environment_instance = optional(object({
      org_managers         = set(string)
      org_billing_managers = set(string)
      org_auditors         = set(string)
      cf_org_user          = set(string)
      spaces = list(object({
        space_name       = string
        space_managers   = set(string)
        space_developers = set(string)
        space_auditors   = set(string)
      }))
    }), null)
  }))
  description = "Collection of stages for which subaccounts shall be created."
}

variable "username" {
  description = "BTP username"
  type        = string
  sensitive   = true

}

variable "password" {
  description = "BTP user password"
  type        = string
  sensitive   = true
}