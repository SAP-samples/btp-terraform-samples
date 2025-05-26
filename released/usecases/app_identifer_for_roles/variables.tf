variable "globalaccount" {
  description = "The subdomainof the global account to use for the SAP BTP provider"
  type        = string
}

variable "region" {
  description = "The region of the subaccount"
  type        = string
  default     = "us10"
}
