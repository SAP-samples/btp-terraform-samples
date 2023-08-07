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
# Cloudfoundry API endpoint URL
variable "cf_api_endpoint" {
  type        = string
  description = "The Cloudfoundry API endpoint URL"
  default     = "https://api.cf.us10.hana.ondemand.com/"
}
# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com", "rui.nogueira@sap.com"]
}

variable "cf_space_developers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space developers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_space_auditors" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space auditors"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

###
# Entitlements
###
variable "entitlements" {
type = list(object({
    service_name = string
    plan_name    = string
    parameters   = string
    type         = string
    environment  = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = [
              {
                service_name = "connectivity"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "destination"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "html5-apps-repo"
                plan_name    = "app-host",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "sapappstudio"
                plan_name    = "standard-edition",
                type         = "app"
                parameters   = null
                environment = "btp"
              },
              {
                service_name = "enterprise-messaging"
                plan_name    = "default",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "application-logs"
                plan_name    = "lite",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "xsuaa"
                plan_name    = "application",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },/*
              {
                service_name = "hana"
                plan_name    = "hdi-shared",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },
              {
                service_name = "hana-cloud"
                plan_name    = "hana",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },  */
              {
                service_name = "autoscaler"
                plan_name    = "standard",
                type         = "service"
                parameters   = null
                environment = "cloudfoundry"
              },  
              {
                service_name = "enterprise-messaging-hub"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
                environment  = null
              },  
              {
                service_name = "SAPLaunchpad"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
                environment  = null
              },  
              {
                service_name = "cicd-app"
                plan_name    = "default",
                type         = "app"
                parameters   = null
                environment  = null
              },  
              {
                service_name = "alm-ts"
                plan_name    = "standard",
                type         = "app"
                parameters   = null
                environment  = null
              }
      ]
}
