###
# Subacount parameters
###
variable "region" {
  type        = string
  description = "The region where the account shall be created in."
  default     = "us10"
}

variable "subacount_name" {
  type        = string
  description = "The name of the subaccount."
  default     = "BTP Terraform Multiprovider Sample"
}

variable "subacount_subdomain" {
  type        = string
  description = "The name of the subaccount subdomain."
  default     = "tf-sample-multiprovider"
}

###
# Entitlements
###
variable "entitlements" {
type = map(object({
    service_name = string
    plan_name    = string
  }))
  description = "The list of entitlements that shall be added to the subaccount."
  default = {
    "one-inbox-service" = {
      service_name = "one-inbox-service"
      plan_name    = "standard"
    }
    "SAPLaunchpad" = {
      service_name = "SAPLaunchpad"
      plan_name    = "standard"
    }
    "destination" = {
      service_name = "destination"
      plan_name    = "lite"
    }
  }  
}

###
# Cloud Foundry parameters
###
variable "cloudfoundry_org_name" {
  type        = string
  description = "The name of the cloud foundry org."
  default     = "tf-cforg"
}

variable "cloudfoundry_space_name" {
  type        = string
  description = "The name of the cloud foundry space."
  default     = "development"
}

###
# User and Roles for subaccount and Cloud Foundry
###
variable "cloudfoundry_space_managers" {
  type        = list(string)
  description = "The list of users that shall be CF space managers."
}

variable "cloudfoundry_space_developers" {
  type        = list(string)
  description = "The list of users that shall be CF space developers."
}

variable "cloudfoundry_space_auditors" {
  type        = list(string)
  description = "The list of users that shall be CF space auditors."
}

variable "subaccount_admins" {
  type = set(string)
  description = "The list of users that shall be subaccount admins."
}

variable "subaccount_service_admins" {
  type = set(string)
  description = "The list of users that shall be subaccount admins."
}
