variable "subaccount_name" {
  description = "Name of the subacccount."
  type        = string
}

variable "subaccount_subdomain" {
  description = "Subdomain for the subaccount."
  type        = string
}

variable "region" {
  type        = string
  description = "Region where the subaccount will be running."
}

variable "parent_directory_id" {
  type        = string
  description = "Id of the parent directory or null for global account as parent."
  default     = null
}

variable "subaccount_labels" {
  description = "Labels for the subaccount."
  type        = map(set(string))
  default     = null
}

variable "entitlements" {
  type = list(object({
    type   = string
    name   = string
    plan   = string
    amount = number
  }))
  description = "List of entitlements for the subaccount."
  default     = []
}

variable "subscriptions" {
  type = list(object({
    app  = string
    plan = string
  }))
  description = "List of subscriptions for the subaccount."
  default     = []
}

variable "role_collection_assignments" {
  type = list(object({
    role_collection_name = string
    user                 = string
  }))
  description = "List of role collection assignments for the subaccount."
  default     = []
}

variable "cf_env_instance_name" {
  type        = string
  description = "Name of the Cloud Foundry environment instance."
  default     = ""
}

variable "cf_org_name" {
  type        = string
  description = "Name of the Cloud Foundry org."
  default     = ""
}

variable "cf_org_managers" {
  type        = set(string)
  description = "List of Cloud Foundry org managers."
  default     = []
}

variable "cf_org_billing_managers" {
  type        = set(string)
  description = "List of Cloud Foundry org billing managers."
  default     = []
}

variable "cf_org_auditors" {
  type        = set(string)
  description = "List of Cloud Foundry org auditors."
  default     = []
}

variable "cf_org_user" {
  type        = set(string)
  description = "List of Cloud Foundry org users (Space users who need to be added as CF org users before assigning space-specific roles)."
  default     = []
}

variable "origin" {
  type        = string
  description = "Origin of the user"
  default     = "sap.ids"
}

variable "cf_spaces" {
  type = list(object({
    space_name       = string
    space_managers   = set(string)
    space_developers = set(string)
    space_auditors   = set(string)
  }))
  description = "List of Cloud Foundry spaces."
  default     = []
}