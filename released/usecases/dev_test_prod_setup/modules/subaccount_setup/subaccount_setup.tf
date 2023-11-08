# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta1"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
locals {
  project_subaccount_name   = "${var.unit_shortname}_${var.stage}"
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
module "cloudfoundry_environment" {
  source = "../../../../modules/environment/cloudfoundry/envinstance_cf"

  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  cf_org_name           = local.project_subaccount_cf_org
  cf_org_managers         = var.emergency_admins
  cf_org_billing_managers = var.emergency_admins
  cf_org_auditors         = var.emergency_admins

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
