###
# Possible values for entering the business unit
###
variable "unit" {
  type        = string
  description = "Defines to which organisation the sub account shall belong to."
  default     = "Research"

  validation {
    condition     = contains(concat(["Research", "Test", "Sales", "Purchase", "Production", "Integration Test"]), var.unit)
    error_message = "Please select a valid org name for the project account."
  }
}

###
# Possible values for entering the short name business unit
###
variable "unit_shortname" {
  type        = string
  description = "Short name for the organisation the sub account shall belong to."
  default     = "Test"


  validation {
    condition     = can(regex("^[a-zA-Z0-9_]", var.unit_shortname))
    error_message = "Please enter a valid short name for the 'unit' the subaccount is assigned to."
  }
}

###
# Email address of the architect
###
variable "architect" {
  type        = string
  description = "Defines the email address of the architect for the subaccount"

  validation {
    condition     = can(regex("(@yourorg.com|@test.com)$", var.architect))
    error_message = "Please enter a valid email address for the architect of the subaccount."
  }
}

###
# Custom IDP for the sub account
###
variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = "terraformint"

  validation {
    condition     = can(regex("^[a-z-]", var.custom_idp))
    error_message = "Please enter a valid entry for the custom-idp of the subaccount."
  }
}

###
# Custom parent_directory_id for the sub account
###
variable "parent_directory_id" {
  type        = string
  description = "Defines the id of the parent direcrory."
}

###
# Email address of the costreference
###
variable "costcenter" {
  type        = string
  description = "Defines the costcenter for the subaccount"

  validation {
    condition     = can(regex("^[0-9]{10}$", var.costcenter))
    error_message = "Please enter a valid costcenter for the business unit."
  }
}

###
# Owner of the subaccount
###
variable "owner" {
  type        = string
  description = "Defines the owner of the subaccount"
  default     = "jane.doe@test.com"

  validation {
    condition     = can(regex("(@yourorg.com|@test.com)$", var.owner))
    error_message = "Please enter a valid email address for the owner of the sub account."
  }
}

###
# Team of the sub account
###
variable "team" {
  type        = string
  description = "Defines the team of the sub account"
  default     = "sap.team@test.com"

  validation {
    condition     = can(regex("(@yourorg.com|@test.com)$", var.team))
    error_message = "Please enter a valid email address for the team of the sub account."
  }
}

###
# Stage of the subaccount
###
variable "stage" {
  type        = string
  description = "The stage/tier the sub account will be used for."
  default     = "DEV"

  validation {
    condition     = contains(["DEV", "TST", "PRD", "EDU"], var.stage)
    error_message = "Select a valid stage for the sub account."
  }
}

###
# Region of BTP sub account
###
variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}

variable "emergency_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

###
# Entitlements
###
variable "entitlements" {
  description = "List of entitlements for a BTP subaccount"
  type = list(object({
    group  = string
    type   = string
    name   = string
    plan   = string
    amount = number
  }))

  default = [
    {
      group  = "Audit + Application Log"
      type   = "service"
      name   = "auditlog-viewer"
      plan   = "free"
      amount = null
    },
    {
      group  = "Alert"
      type   = "service"
      name   = "alert-notification"
      plan   = "standard"
      amount = null
    },
    {
      group  = "SAP HANA Cloud"
      type   = "service"
      name   = "hana-cloud"
      plan   = "hana"
      amount = null
    },
    {
      group  = "SAP HANA Cloud"
      type   = "service"
      name   = "hana"
      plan   = "hdi-shared"
      amount = null
    }
  ]
}
