variable "globalaccount" {
  type        = string
  description = "The subdomain of the SAP BTP global account."
  default = "terraformintprod"
}

variable "idp" {
  type        = string
  description = "Orgin key of Identity Provider"
  default     = null
}
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
variable "project_name" {
  type        = string
  description = "The subaccount name."
  default     = "Terramte"

  validation {
    condition     = can(regex("^[a-zA-Z0-9_\\-]{1,200}", var.project_name))
    error_message = "Provide a valid project name."
  }
}
variable "stage" {
  type        = string
  description = "The stage/tier the account will be used for."
  default     = "PRD"

  validation {
    condition     = contains(["DEV", "TST", "PRD"], var.stage)
    error_message = "Select a valid stage for the project account."
  }
}
variable "costcenter" {
  type        = string
  description = "The cost center the account will be billed to."
  default     = "1234567890"

  validation {
    condition     = can(regex("^[0-9]{10}", var.costcenter))
    error_message = "Provide a valid cost center."
  }
}
variable "org_name" {
  type        = string
  description = "Defines to which organization the project account shall belong to."
  default     = "B2C"
}
variable "bas_admins" {
  type        = list(string)
  description = "List of users to assign the Administrator role."
  default = [ "admin1@test.com","adminnew@test.com" ]

}
variable "bas_developers" {
  type        = list(string)
  description = "List of users to assign the Developer role."
  default = [ "developer1@test.com","developer2@test.com" ]
}
variable "bas_service_name" {
  type        = string
  description = "Service name for Business Application Studio."
  default     = "sapappstudio"

}
variable "bas_plan" {
  type        = string
  description = "Plan name for Business Application Studio."
  default     = "standard-edition"
}

variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "cf-us10-001"
}
variable "cf_plan" {
  type        = string
  description = "Plan name for Cloud Foundry Runtime."
  default     = "standard"
}
variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "prod"
}

variable "cf_org_user" {
  type        = set(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_managers" {
  type        = list(string)
  description = "The list of Cloud Foundry space managers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}

variable "cf_space_developers" {
  type        = list(string)
  description = "The list of Cloud Foundry space developers."
  default     = ["prajin.ollekkatt.prakasan@sap.com"]
}


