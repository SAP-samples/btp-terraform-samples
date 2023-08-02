######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
  default     = "yourglobalaccount"
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "UC - Build resilient BTP Apps"
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

###
# Entitlements
###
variable "entitlements" {
type = list(object({
    service_name = string
    plan_name    = string
    parameters   = string
    type        = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = [
              {
                service_name = "connectivity"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "sapappstudio"
                plan_name    = "standard-edition",
                type         = "app"
                parameters   = null
              },
  ]
}
