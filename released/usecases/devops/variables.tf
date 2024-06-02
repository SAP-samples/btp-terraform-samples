variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}
variable "directory" {
  type        = string
  description = "Directory name"
  default     = "terraform-demo"
}
variable "directory_desc" {
  type        = string
  description = "Directory description"
  default     = "Project ABCD"
}
variable "directory_labels" {
  type        = map(set(string))
  description = "Labels for directory"
}
variable "subaccount_labels" {
  type        = map(set(string))
  description = "Labels for directory"
  default = {
    "name" = ["value"]
  }
}
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount"
}

variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}


variable "custom_idp" {
  type        = string
  description = "Defines the custom IDP to be used for the subaccount"
  default     = ""
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"
}

variable "org" {
  type        = string
  description = "Your SAP BTP org e.g. department"
  default     = "org"
}

variable "cicd_service_plan" {
  type        = string
  description = "The plan for Continous Integration & Delivery subscription"
  default     = "free"
  validation {
    condition     = contains(["free", "default"], var.cicd_service_plan)
    error_message = "Invalid value for Continous Integraion & Delivery. Only 'free' and 'default' are allowed."
  }
}

variable "cicd_service_params" {
  type        = string
  description = "The parameters for the CI/CD service instance"
  default     = ""
}

variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

variable "developers" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as developers."
}

variable "btp_username" {
  type        = string
  description = "SAP BTP user name"
}

variable "btp_password" {
  type        = string
  description = "Password for SAP BTP user"
  sensitive   = true
}

variable "cf_space" {
  type        = string
  description = "Name of the cloud foundry space"
}

variable "cf_url" {
  type        = string
  description = "URL of Cloud Foundry landscape"
}

variable "cf_admins" {
  type        = list(string)
  description = "Name of the cloud foundry space"
  default     = []
}

variable "environment_label" {
  type        = string
  description = "In case there are multiple environments available for a subaccount, you can use this label to choose with which one you want to go. If nothing is given, we take by default the first available."
  default     = ""
}
variable "origin" {
  type        = string
  description = "The origin for the IAS account for platform-users - if not set the sap.ids would be taken"
  default     = ""
}

variable "hana_system_password" {
  type        = string
  description = "Password for the SAP HANA Cloud SYSTEM user"
}

variable "hana_db_name" {
  type        = string
  description = "Name of the SAP HANA Cloud DB"
}