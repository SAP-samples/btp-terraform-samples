variable "cf_api_url" {
  type = string
}

variable "cf_landscape_label" {
  type = string
}

variable "cf_org_id" {
  type = string
}

variable "subaccount_id" {
  type = string
}

variable "cf_space_developers" {
  type        = list(string)
  description = "CF Space developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "CF Space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_admins" {
  type        = list(string)
  description = "CF Org Admins"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_users" {
  type        = list(string)
  description = "CF Org Users"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}
