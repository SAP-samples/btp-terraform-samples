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
                service_name = "destination"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "html5-apps-repo"
                plan_name    = "app-host",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "sapappstudio"
                plan_name    = "standard-edition",
                type         = "app"
                parameters   = null
              },
              {
                service_name = "enterprise-messaging"
                plan_name    = "default",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "application-logs"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "xsuaa"
                plan_name    = "application",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "hana"
                plan_name    = "hdi-shared",
                type         = "service"
                parameters   = null
              },
              {
                service_name = "hana-cloud"
                plan_name    = "hana",
                type         = "service"
                parameters   = null
              },  
              {
                service_name = "autoscaler"
                plan_name    = "standard",
                type         = "service"
                parameters   = null
              },  
              {
                service_name = "enterprise-messaging-hub"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
              },  
              {
                service_name = "SAPLaunchpad"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
              },  
              {
                service_name = "cicd-app"
                plan_name    = "default",
                type         = "app"
                parameters   = null
              },  
              {
                service_name = "alm-ts"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
              }
      ]
}
