# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.5.0"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
locals {
  project_subaccount_name = "${var.unit_shortname}_${var.stage}"
  # Remove all blanks and substitute all "_" with a "-"
  project_subaccount_domain = replace(lower(replace("${local.project_subaccount_name}", "_", "-")), " ", "")
  project_subaccount_cf_org = replace(join("", ["${var.unit}", "${local.project_subaccount_domain}"]), " ", "")
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  labels = {
    "architect" : ["${var.architect}"]
    "costcenter" : ["${var.costcenter}"],
    "owner" : ["${var.owner}"],
    "team" : ["${var.team}"]
  }
  usage = "USED_FOR_PRODUCTION"

  parent_id = var.parent_directory_id
}

# ------------------------------------------------------------------------------------------------------
# Assignment of emergency admins to the sub account as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each             = toset("${var.emergency_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Setup the trust configuration to map it to the custom IDP
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
}

# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.project.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "replacement" {
  input = length(var.cf_environment_label) > 0 ? var.cf_environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.replacement.output

  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
}

# ------------------------------------------------------------------------------------------------------
# Create all entitlements
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "entitlements" {

  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }

  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.name
  plan_name     = each.value.plan
}
