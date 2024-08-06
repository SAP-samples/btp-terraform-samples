variable "cf_api_url" {
  type = string
}

variable "cf_org_id" {
  type = string
}

variable "cf_origin" {
  description = "Origin used for Cloud Foundry organization and space role assignments"
  type        = string
  default     = "sap.ids"
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
  default     = []
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
  default     = []
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
  default     = []
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
  default     = []
}
