variable "cf_org_id" {
  type        = string
  description = "The ID of the Cloud Foundry org."
}

variable "name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}

variable "region" {
  type        = string
  description = "The BTP region for the Cloudfoundry instance"
  default     = "eu10"
}

variable "api_url" {
  type        = string
  description = "The CF API URL"
  default     = "https://api.cf.us10.hana.ondemand.com"
}

variable "cf_space_managers"{
  type = list(string)
  description = "The list of Cloud Foundry space managers."
  default = []
}

variable "cf_space_developers"{
  type = list(string)
  description = "The list of Cloud Foundry space developers."
  default = []
}

variable "cf_space_auditors"{
  type = list(string)
  description = "The list of Cloud Foundry space auditors."
  default = []
}