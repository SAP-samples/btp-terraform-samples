# ------------------------------------------------------------------------------------------------------
# Account variables
# ------------------------------------------------------------------------------------------------------
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cli.btp.cloud.sap"
}

variable "region" {
  type        = string
  description = "The region where the subaccount shall be created in."
  default     = "us10"
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP DC mission subaccount."
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

# ------------------------------------------------------------------------------------------------------
# app subscription plans
# ------------------------------------------------------------------------------------------------------
variable "service_plan__build_code" {
  type        = string
  description = "The plan for service 'SAP Build Code' with technical name 'build-code'"
  default     = "free"
  validation {
    condition     = contains(["free"], var.service_plan__build_code)
    error_message = "Invalid value for service_plan__build_code. Only 'free' is allowed."
  }
}

# ------------------------------------------------------------------------------------------------------
# User lists
# ------------------------------------------------------------------------------------------------------
variable "build_code_admins" {
  type        = list(string)
  description = "Defines the colleagues who are admins for SAP Build Code."
}
variable "build_code_developers" {
  type        = list(string)
  description = "Defines the colleagues who are developers for SAP Build Code."
}
