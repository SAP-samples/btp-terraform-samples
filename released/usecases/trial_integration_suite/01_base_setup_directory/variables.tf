variable "globalaccount" {
  description = "Subdomain of the global account"
  type        = string
}

variable "directory_name" {
  description = "Name of the directory"
  type        = string
  default     = "Integration Directory"
}

variable "directory_description" {
  description = "Description of the directory"
  type        = string
  default     = "Directory for all integration subaccounts"
}

variable "features" {
  description = "Directory features to be activated"
  type        = list(string)
  default     = ["DEFAULT"]
  validation {
    condition     = alltrue([for feature in var.features : contains(["DEFAULT", "ENTITLEMENTS", "AUTHORIZATIONS"], feature)])
    error_message = "The only supported features are DEFAULT, ENTITLEMENTS and AUTHORIZATIONS"
  }
}

variable "project_costcenter" {
  description = "Cost center of the project"
  type        = string
  validation {
    condition     = can(regex("^[0-9]{5}$", var.project_costcenter))
    error_message = "Cost center must be a 5 digit number"
  }
}

variable "entitlement_assignments" {
  description = "list of entitlements to be assigned ot the directory"
  type = list(object({
    name        = string
    plan        = string
    amount      = number
    distribute  = bool
    auto_assign = bool
  }))
  default = []
}

variable "role_collection_assignments" {
  description = "List of role collections to assign to a user"
  type = list(object({
    role_collection_name = string
    users                = set(string)
  }))
  default = []
}
