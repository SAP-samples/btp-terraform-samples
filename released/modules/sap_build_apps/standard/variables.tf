variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}

variable "entitlements" {
  description = "List of entitlements for a BTP subaccount"
    type = list(object({
      name = string
      plan = string
      type = string
  }))
}