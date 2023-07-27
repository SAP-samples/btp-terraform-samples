variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}
/*
variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default = "terraformint"

  validation {
    condition = can(regex("^[a-z-]", var.custom_idp))
    error_message = "Please enter a valid entry for the custom-idp of the subaccount."
  }
}
*/
