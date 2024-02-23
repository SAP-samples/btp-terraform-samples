variable "subaccount_name" {
  type        = string
  description = "The name of the subaccount."
  default     = "devcontainer-runtime"
}

variable "subaccount_subdomain" {
  type        = string
  description = "The subdomain of the subaccount."
  default     = "devcontainer-runtime"
}

variable "region" {
  type        = string
  description = "The BTP region the devcontainer runtime shall be created in."
  default     = "us10"
}

variable "users" {
  type        = set(string)
  description = "Users that shall have access to the runtime."
  default     = []
}
