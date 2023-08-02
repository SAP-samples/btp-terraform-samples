# subaccount
variable "name" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
}
# subaccount
variable "plan" {
  type        = string
  description = "The subaccount name."
  default     = "UC - Build resilient BTP Apps"
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}