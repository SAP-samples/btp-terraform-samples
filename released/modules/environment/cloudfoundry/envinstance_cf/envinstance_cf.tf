# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "0.6.0-beta2"
    }
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Fetch all available environments for the subaccount
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount_environments" "all" {
  subaccount_id = var.subaccount_id
}

# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# ------------------------------------------------------------------------------------------------------
resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.environment_label) > 0 ? var.environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = var.subaccount_id
  name             = var.instance_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.plan_name
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = var.cf_org_name
  })
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry org users
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_org_users" "org_users" {
  org              = btp_subaccount_environment_instance.cf.platform_id
  managers         = var.cf_org_managers
  billing_managers = var.cf_org_billing_managers
  auditors         = var.cf_org_auditors
}