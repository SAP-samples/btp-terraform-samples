######################################################################
# Customer account setup
######################################################################
variable "globalaccount" {
  type        = string
  description = "Defines the global account"
  default     = "yourglobalaccount"
}

variable "cli_server_url" {
  type        = string
  description = "Defines the CLI server URL"
  default     = "https://cli.btp.cloud.sap"
}

# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "SAP Discovery Center Mission 3774 - Central Inbox with SAP Task Center"
}
variable "subaccount_id" {
  type        = string
  description = "The subaccount ID."
  default     = ""
}

variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_admins)
    error_message = "Please enter a valid email address for the CF space managers."
  }
}

variable "subaccount_service_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount service administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.subaccount_service_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.subaccount_service_admins)
    error_message = "Please enter a valid email address for the CF space managers."
  }
}

variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"

  # Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for the latest list of regions
  # supported by the AI Core service with the "extended" service plan.
  validation {
    condition     = contains(["ap10", "eu10", "eu11", "eu20", "eu30", "jp10", "us10", "us21", "us30"], var.region)
    error_message = "Please enter a valid region for the sub account. Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for regions providing the AI Core service."
  }
}


variable "hana_cloud_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added as admins to access the instance of SAP HANA Cloud."
  default     = ["jane.doe@test.com", "john.doe@test.com"]

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.hana_cloud_admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.hana_cloud_admins)
    error_message = "Please enter a valid email address for the admins of SAP HANA Cloud instance."
  }
}

variable "custom_idp" {
  type        = string
  description = "Defines the custom IdP"
  default     = ""
}

# variable "origin" {
#   type        = string
#   description = "Defines the origin key of the identity provider"
#   default     = "sap.ids"
#   # The value for the origin_key can be defined
#   # but are normally set to "sap.ids", "sap.default" or "sap.custom"
# }


variable "create_tfvars_file_for_step2" {
  type        = bool
  description = "Switch to enable the creation of the tfvars file for step 2."
  default     = false
}

variable "ai_core_plan_name" {
  type        = string
  description = "The name of the AI Core service plan."
  default     = "extended"
  validation {
    condition     = contains(["extended"], var.ai_core_plan_name)
    error_message = "Valid values for ai_core_plan_name are: extended."
  }
}

variable "hana_system_password" {
  type        = string
  description = "The password of the database 'superuser' DBADMIN."
  sensitive   = true

  # add validation to check if the password is at least 8 characters long
  validation {
    condition     = length(var.hana_system_password) > 7
    error_message = "The hana_system_password must be at least 8 characters long."
  }

  # add validation to check if the password contains at least one upper case
  validation {
    condition     = can(regex("[A-Z]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one upper case."
  }

  # add validation to check if the password contains at least two lower case characters that can occur on arbitrary places in the string (not necessarily in a row)
  validation {
    condition     = length(regexall("[a-z]", var.hana_system_password)) > 1
    error_message = "The hana_system_password must contain at least two lower case characters."
  }

  # add validation to check if the password contains at least one numeric character
  validation {
    condition     = can(regex("[0-9]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one numeric character."
  }
}

variable "target_ai_core_model" {
  type        = list(any)
  description = "Defines the target AI core model to be used by the AI Core service"
  default     = ["gpt-35-turbo"]

  validation {
    condition = length([
      for o in var.target_ai_core_model : true
      if contains(["gpt-35-turbo", "gpt-35-turbo-0125", "gpt-35-turbo-16k", "gpt-4", "gpt-4-32k", "text-embedding-ada-002", "gemini-1.0-pro", "text-bison", "chat-bison", "textembedding-gecko-multilingual", "textembedding-gecko", "tiiuae--falcon-40b-instruct"], o)
    ]) == length(var.target_ai_core_model)
    error_message = "Please enter a valid entry for the target_ai_core_model of the AI Core service. Valid values are: gpt-35-turbo, gpt-35-turbo-16k, gpt-4, gpt-4-32k, text-embedding-ada-002, tiiuae--falcon-40b-instruct."
  }
}

# cf org name
variable "cf_org_name" {
  type        = string
  description = "Cloud Foundry Org Name"
  default     = "cloud-foundry"
}

# credential store
variable "credstore_plan_name" {
  type        = string
  description = "The name of the Credential Store plan."
  default     = "free"
  validation {
    condition     = contains(["free", "standard"], var.credstore_plan_name)
    error_message = "Valid values for Credential Store plan are: free, standard."
  }
}
