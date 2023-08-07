variable "name" {
  type        = string
  description = "The globalaccount subdomain."
}

variable "cf_org_id"{
    type = string
}

variable "plan" {
  type        = string
  description = "The subaccount name."
}

variable "parameters"{
    type = string
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}
