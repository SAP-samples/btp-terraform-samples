variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain where the sub account shall be created."
}

variable "setup_ai_launchpad" {
  type        = bool
  description = "Switch to enable the setup of the AI Launchpad."
  default     = true
}

variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
  default     = "My SAP Build Apps subaccount."
}

variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.sap.hana.ondemand.com"
}


variable "region" {
  type        = string
  description = "The region where the sub account shall be created in."
  default     = "us10"

  # Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for the latest list of regions
  # supported by the AI Core service.
  validation {
    condition     = contains(["eu10-canary", "ap10", "eu10", "eu11", "jp10", "us10"], var.region)
    error_message = "Please enter a valid region for the sub account. Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for regions providing the AI Core service."
  }
}

variable "admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as emergency administrators."

  # add validation to check if admins contains a list of valid email addresses
  validation {
    condition     = length([for email in var.admins : can(regex("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$", email))]) == length(var.admins)
    error_message = "Please enter a valid email address for the admins."
  }
}

# -----------------------------------------------------------------------------
# Services
# -----------------------------------------------------------------------------
variable "build_code_services" {
  description = "List of services to be setup"
  type = list(object({
    environment = string
    name        = string
    plan        = string
    amount      = number
  }))

  default = [
    {
      environment = "cloudfoundry"
      name        = "sdm"
      plan        = "build-code"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "mobile-services"
      plan        = "build-code"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "transport"
      plan        = "standard"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "cloud-logging"
      plan        = "build-code"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "autoscaler"
      plan        = "standard"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "feature-flags"
      plan        = "standard"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "cicd-service"
      plan        = "default"
      amount      = null
    },
    {
      environment = "cloudfoundry"
      name        = "alert-notification"
      plan        = "build-code"
      amount      = null
    }
  ]
}

# -----------------------------------------------------------------------------
# Subscriptions
# -----------------------------------------------------------------------------
variable "build_code_subscriptions" {
  description = "List of app subscriptions to be setup"
  type = list(object({
    name = string
    plan = string
  }))

  default = [
    {
      name = "build-code"
      plan = "standard"
    },
    {
      name = "sapappstudio"
      plan = "build-code"
    },
    {
      name = "SAPLaunchpad"
      plan = "foundation"
    },
    {
      name = "cicd-app"
      plan = "build-code"
    },
    {
      name = "sapappstudio"
      plan = "build-code"
    },
    {
      name = "alm-ts"
      plan = "build-code"
    },
    {
      name = "sdm-web"
      plan = "build-code"
    },
    {
      name = "feature-flags-dashboard"
      plan = "dashboard"
    }
  ]
}
