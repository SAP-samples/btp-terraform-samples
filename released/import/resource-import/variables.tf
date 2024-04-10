variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
}

variable "subaccount_region" {
  type        = string
  description = "The subaccount region."
}

variable "subaccount_subdomain" {
  type        = string
  description = "The subaccount subdomain."
}

variable "subaccount_usage" {
  type        = string
  description = "The subaccount usage."
}

variable "subaccount_labels" {
  type        = map(set(string))
  description = "The subaccount labels."
}

variable "service_name" {
  type        = string
  description = "The service name."
}

variable "service_plan_name" {
  type        = string
  description = "The service plan name."
}

// Only needed for the import
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
}
