variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP subaccount"
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}
variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "org" {
  type        = string
  description = "Your SAP BTP org e.g. department or costcenter"
  default     = "org"
}

variable "build_workzone_service_plan" {
  type        = string
  description = "The plan for the SAP Build Workzone subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.build_workzone_service_plan)
    error_message = "Invalid value for build_workzone_service_plan. Only 'free' and 'standard' are allowed."
  }
}

variable "bas_service_plan" {
  type        = string
  description = "The plan for SAP Business Application Studio subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "standard-edition"], var.bas_service_plan)
    error_message = "Invalid value for SAP Business Application Studion. Only 'free' and 'standard-edition' are allowed."
  }
}

variable "cicd_service_plan" {
  type        = string
  description = "The plan for Continous Integraion & Delivery subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "default"], var.cicd_service_plan)
    error_message = "Invalid value for Continous Integraion & Delivery. Only 'free' and 'default' are allowed."
  }
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}
variable "service_admins" {
  type        = list(string)
  description = "Defines the users who are added to each subaccount as service administrators."
}
variable "developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to services as developers."
}

variable "btp_username" {
  type        = string
  description = "SAP BTP user name"
  default     = ""
}


variable "btp_password" {
  type        = string
  description = "Password for SAP BTP user"
  sensitive   = true
  default     = ""
}
