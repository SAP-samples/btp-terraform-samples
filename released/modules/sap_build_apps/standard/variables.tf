variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}

variable "users_BuildAppsAdmin" {
  type        = list(string)
  description = "Users to get role of BuildAppsAdmin"
}

variable "users_BuildAppsDeveloper" {
  type        = list(string)
  description = "Users to get role of BuildAppsDeveloper"
}

variable "users_RegistryAdmin" {
  type        = list(string)
  description = "Users to get role of RegistryAdmin"
}

variable "users_RegistryDeveloper" {
  type        = list(string)
  description = "Users to get role of RegistryDeveloper"
}

variable "custom_idp_origin" {
  type        = string
  description = "Defines the custom IDP origin for the role collection"
  default     = "sap.custom"
}

variable "subaccount_domain" {
  type        = string
  description = "The subaccount domain."
}

variable "region" {
  type        = string
  description = "The used region."
}