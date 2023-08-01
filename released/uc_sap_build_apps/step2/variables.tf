variable "org_id" {
  type        = string
  description = "The org ID od the Cloudfoundry environment instance."
}

variable "api_endpoint" {
  type        = string
  description = "The org ID od the Cloudfoundry environment instance."
}

variable "subaccount_cf_org" {
  type        = string
  description = "The subaccount CF org."
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space auditors"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

