######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
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
variable "cf_space_name" {
  type        = string
  description = "The Cloudfoundry space name"
  default     = "dev"
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

variable "cf_org_auditors" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry org auditors"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_managers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry org auditors"
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}

variable "cf_org_billing_managers" {
  type        = list(string)
  description = "Defines the colleagues who are Cloudfoundry org auditors"
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
      service_name = "enterprise-messaging"
      plan_name    = "default",
      type         = "service"
    },
    {
      service_name = "enterprise-messaging-hub"
      plan_name    = "standard",
      type         = "app"
    },
    {
      service_name = "privatelink"
      plan_name    = "standard",
      type         = "service"
    },
    {
      service_name = "xsuaa"
      plan_name    = "application",
      type         = "service"
    },
    {
      service_name = "hana"
      plan_name    = "hdi-shared",
      type         = "service"
    },
    {
      service_name = "hana-cloud"
      plan_name    = "hana",
      type         = "service"
    }
  ]
}
variable "btp_user" {
description = "BTP user email"
type = string
}

# Plan_name update
variable "bas_plan_name" {
description = "BAS plan"
type = string
default = "free-tier"
}

variable "build_workzone_plan_name" {
description = "Build Workzone plan"
type = string
default = "free-tier"
}

variable "hana-cloud_plan_name" {
description = "hana-cloud plan"
type = string
default = "free"
}
