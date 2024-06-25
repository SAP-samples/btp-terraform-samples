# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "sap/btp"
      version = "~> 1.4.0"
    }
    cloudfoundry = {
      source  = "SAP/cloudfoundry"
      version = "0.2.1-beta"
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
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "30m"
  }
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry org users
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_org_role" "org_role" {
  for_each = var.cf_org_user
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cf.platform_id
}

resource "cloudfoundry_org_role" "manager_role" {
  for_each = var.cf_org_managers
  username = each.value
  type     = "organization_manager"
  org      = btp_subaccount_environment_instance.cf.platform_id
}

resource "cloudfoundry_org_role" "auditor_role" {
  for_each = var.cf_org_auditors
  username = each.value
  type     = "organization_auditor"
  org      = btp_subaccount_environment_instance.cf.platform_id
}

resource "cloudfoundry_org_role" "billing_role" {
  for_each = var.cf_org_billing_managers
  username = each.value
  type     = "organization_auditor"
  org      = btp_subaccount_environment_instance.cf.platform_id
}


