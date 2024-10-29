variable "globalaccount" {
  description = "Subdomain of your Globalaccount"
  type        = string
}

variable "subaccount_id" {
  description = "The ID of the existing subaccount."
  type        = string
}

variable "role_collection_assignments" {
  description = "A map of role collections and their assigned users."
  type = map(object({
    role_collection_name = string
    users                = list(string)
  }))
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}
