variable "globalaccount" {
  description = "Subdomain of the global account"
  type        = string
}

variable "cf_landscape_label" {
  description = "Label of the Cloud Foundry landscape"
  type        = string
  default     = "us10-001"
  validation {
    condition     = contains(["us10-001", "ap21"], var.cf_landscape_label)
    error_message = "Trial landscape must be one of us10-001 or ap21"
  }
}

variable "directory_id" {
  description = "The ID of the directory"
  type        = string
}

variable "subaccount_id" {
  description = "The ID of the subaccount"
  type        = string
}

variable "space_id" {
  description = "The ID of the CLoud Foudnry space"
  type        = string
}

variable "pi_admins" {
  description = "List of PI admins"
  type        = list(string)
  default     = []
}

variable "pi_business_experts" {
  description = "List of eÜI Business Experts"
  type        = list(string)
  default     = []
}

variable "pi_integration_developers" {
  description = "List of PI integration developers"
  type        = list(string)
  default     = []
}

variable "pi_readonly" {
  description = "List of PI Read Only users"
  type        = list(string)
  default     = []
}
