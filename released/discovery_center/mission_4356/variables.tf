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
  default     = "UC - Deliver Connected Experiences with a single view of Material Availability"
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}

# hana password
variable "hana_cloud_system_password" {
  type        = string
  description = "The system password for the hana_cloud service instance."
  default     = "Abcd1234"
}

# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}


###
# Entitlements
###
variable "entitlements" {
  type = list(object({
    service_name = string
    plan_name    = string
    type         = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = [
    {
      service_name = "connectivity"
      plan_name    = "lite",
      type         = "service"
    },
    {
      service_name = "destination"
      plan_name    = "lite",
      type         = "service"
    },
    {
      service_name = "html5-apps-repo"
      plan_name    = "app-host",
      type         = "service"
    },
    {
      service_name = "sapappstudio"
      plan_name    = "standard-edition",
      type         = "app"
    },
    {
      service_name = "xsuaa"
      plan_name    = "application",
      type         = "service"
    },
    {
      service_name = "integrationsuite"
      plan_name    = "enterprise_agreement",
      type         = "app"
    }
  ]
}

variable "appstudio_developers" {
  type        = list(string)
  description = "Business Application Studio Developer"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "appstudio_admin" {
  type        = list(string)
  description = "Business Application Studio Administrator"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cloudconnector_admin" {
  type        = list(string)
  description = "Cloud Connector Administrator"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "conn_dest_admin" {
  type        = list(string)
  description = "Connectivity and Destination Administrator"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "int_provisioner" {
  type        = list(string)
  description = "Integration Provisioner"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "username" {
  description = "BTP username"
  type        = string
  sensitive   = false

}

variable "password" {
  description = "BTP user password"
  type        = string
  sensitive   = true
}

# Cloudfoundry environment label
variable "cf_environment_label" {
  type        = string
  description = "The Cloudfoundry environment label"
  default     = "cf-us10"
}
