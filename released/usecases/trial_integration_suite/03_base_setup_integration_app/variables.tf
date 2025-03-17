variable "globalaccount" {
  description = "Subdomain of the global account"
  type        = string
}

variable "subaccount_id" {
  description = "The ID of the subaccount"
  type        = string
}

variable "integration_provisioners" {
  description = "List of user that should be assigned as integration provisioners"
  type        = list(string)
  default     = []
}
