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
  default     = "Resilient BTP Apps"
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
# Cloudfoundry environment label
variable "cf_environment_label" {
  type        = string
  description = "The Cloudfoundry environment label"
  default     = "cf-us10"
}

# Cloudfoundry space name
variable "space_name" {
  type        = string
  description = "The Cloudfoundry space name"
  default     = "development"
}

# hana password
variable "hana_cloud_system_password" {
  type        = string
  description = "The system password for the hana_cloud service instance."
  default     = "Abcd1234"
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

variable "cf_org_admins" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry org admins"

}
variable "cf_space_managers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry space managers"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
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

variable "parameters" {
  description = "parameters"
  type        = string
  default     = null
}

variable "type" {
  description = "name"
  type        = string
  default     = "managed"
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
      plan_name    = "lite"
      type         = "service"
    },
    {
      service_name = "destination"
      plan_name    = "lite"
      type         = "service"
    },
    {
      service_name = "sapappstudio"
      plan_name    = "standard-edition"
      type         = "app"
    },
    {
      service_name = "enterprise-messaging"
      plan_name    = "default"
      type         = "service"
    },
    {
      service_name = "application-logs"
      plan_name    = "lite"
      type         = "service"
    },
    {
      service_name = "xsuaa"
      plan_name    = "application"
      type         = "service"
    },
    {
      service_name = "hana"
      plan_name    = "hdi-shared"
      type         = "service"
    },
    {
      service_name = "hana-cloud"
      plan_name    = "hana"
      type         = "service"
    },
    {
      service_name = "autoscaler"
      plan_name    = "standard"
      type         = "service"
    },
    {
      service_name = "enterprise-messaging-hub"
      plan_name    = "standard"
      type         = "app"
    },
    {
      service_name = "SAPLaunchpad"
      plan_name    = "standard"
      type         = "app"
    },
    {
      service_name = "cicd-app"
      plan_name    = "default"
      type         = "app"
    },
    {
      service_name = "alm-ts"
      plan_name    = "standard"
      type         = "app"
    }
  ]
}
