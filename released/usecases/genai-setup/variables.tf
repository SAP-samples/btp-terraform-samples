# Description: This file contains the input variables for the GenAI setup use case.

# ------------------------------------------------------------------------------------------------------
# Input variables
# ------------------------------------------------------------------------------------------------------

# The globalaccount subdomain where the sub account shall be created.
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

# The subaccount name.
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount."
}

# The BTP CLI server URL.
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.sap.hana.ondemand.com"
}

# The name of the AI Core service plan.
variable "ai_core_plan_name" {
  type        = string
  description = "The name of the AI Core service plan."
  default     = "extended"

  # The AI Core service plan name can be only "extended".
  validation {
    condition     = contains(["extended"], var.ai_core_plan_name)
    error_message = "Valid values for ai_core_plan_name are: extended."
  }
}

# The password of the database 'superuser' DBADMIN.
variable "hana_system_password" {
  type        = string
  description = "The password of the database 'superuser' DBADMIN."
  sensitive   = true

  # validation to check if the password is at least 8 characters long
  validation {
    condition     = length(var.hana_system_password) > 7
    error_message = "The hana_system_password must be at least 8 characters long."
  }

  # validation to check if the password contains at least one upper case
  validation {
    condition     = can(regex("[A-Z]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one upper case."
  }

  # validation to check if the password contains at least two lower case characters
  validation {
    condition     = length([for c in var.hana_system_password : c if can(regex("[a-z]", c))]) > 1
    error_message = "The hana_system_password must contain at least two lower case characters."
  }

  # validation to check if the password contains at least one numeric character
  validation {
    condition     = can(regex("[0-9]", var.hana_system_password))
    error_message = "The hana_system_password must contain at least one numeric character."
  }

  # You can as well create another user/password combination for the database
  # within the DB UI and use that one instead of the superuser DBADMIN.

}

# The target AI core model to be used by the AI Core service.
variable "target_ai_core_model" {
  type        = list(any)
  description = "Defines the target AI core model to be used by the AI Core service"
  default     = ["gpt-35-turbo"]

  validation {
    condition = length([
      for o in var.target_ai_core_model : true
      if contains(["gpt-35-turbo", "gpt-35-turbo-16k", "gpt-4", "gpt-4-32k", "text-embedding-ada-002", "tiiuae--falcon-40b-instruct"], o)
    ]) == length(var.target_ai_core_model)
    error_message = "Please enter a valid entry for the target_ai_core_model of the AI Core service. Valid values are: gpt-35-turbo, gpt-35-turbo-16k, gpt-4, gpt-4-32k, text-embedding-ada-002, tiiuae--falcon-40b-instruct."
  }
}

# The region where the sub account shall be created.
variable "region" {
  type        = string
  description = "The region where the sub account shall be created."
  default     = "eu12"

  # The region can be only "eu10", "eu11", "us10".
  validation {
    condition     = contains(["eu10", "eu11", "us10"], var.region)
    error_message = "Valid values for region are: eu10, eu11, us10."
  }
}

# The colleagues who are added to each subaccount as emergency administrators.
variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."
}

# The list of roles to be assigned to the users in the AI Launchpad.
variable "roles_ai_launchpad" {
  type        = list(string)
  description = "Defines the list of roles to be assigned to the users in the AI Launchpad."
  default = [
    "ailaunchpad_aicore_admin_editor",
    "ailaunchpad_aicore_admin_editor_without_genai",
    "ailaunchpad_aicore_admin_viewer",
    "ailaunchpad_aicore_admin_viewer_without_genai",
    "ailaunchpad_allow_all_resourcegroups",
    "ailaunchpad_connections_editor",
    "ailaunchpad_connections_editor_without_genai",
    "ailaunchpad_functions_explorer_editor",
    "ailaunchpad_functions_explorer_editor_v2",
    "ailaunchpad_functions_explorer_editor_v2_without_genai",
    "ailaunchpad_functions_explorer_editor_without_genai",
    "ailaunchpad_functions_explorer_viewer",
    "ailaunchpad_functions_explorer_viewer_v2",
    "ailaunchpad_functions_explorer_viewer_v2_without_genai",
    "ailaunchpad_functions_explorer_viewer_without_genai",
    "ailaunchpad_genai_administrator",
    "ailaunchpad_genai_experimenter",
    "ailaunchpad_genai_manager",
    "ailaunchpad_mloperations_editor",
    "ailaunchpad_mloperations_editor_without_genai",
    "ailaunchpad_mloperations_viewer",
    "ailaunchpad_mloperations_viewer_without_genai"
  ]

}

