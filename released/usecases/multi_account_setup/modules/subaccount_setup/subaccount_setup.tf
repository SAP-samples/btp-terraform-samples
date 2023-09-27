###############################################################################################
# Define the required providers for this module
###############################################################################################
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.4.0-beta1"
    }
  }
}

###
# Check if Cloud Foundry environment should be created
###
locals {
  cf_env = length(var.cf_env_instance_name) > 0
}

###
# Create the subaccount
###
resource "btp_subaccount" "subaccount" {
  name      = var.subaccount_name
  subdomain = var.subaccount_subdomain
  region    = var.region
  labels    = var.subaccount_labels
  parent_id = var.parent_directory_id
}

###
# Add the entitlement(s) to the subaccount
###
resource "btp_subaccount_entitlement" "entitlements" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }

  subaccount_id = btp_subaccount.subaccount.id
  service_name  = each.value.name
  plan_name     = each.value.plan
}

###
# Subscribe to the service(s)
###
resource "btp_subaccount_subscription" "subscriptions" {
  for_each = {
    for index, subscription in var.subscriptions :
    index => subscription
  }

  subaccount_id = btp_subaccount.subaccount.id
  app_name      = each.value.app
  plan_name     = each.value.plan
  depends_on    = [btp_subaccount_entitlement.entitlements, module.cloudfoundry_environment]
}

###
# Assign role collection(s) to user(s)
###
resource "btp_subaccount_role_collection_assignment" "role_collection_assignments" {
  for_each = {
    for index, role_collection_assignment in var.role_collection_assignments :
    index => role_collection_assignment
  }

  subaccount_id        = btp_subaccount.subaccount.id
  role_collection_name = each.value.role_collection_name
  user_name            = each.value.user
  depends_on           = [btp_subaccount_subscription.subscriptions]
}

###
# Create Cloud Foundry environment
###
module "cloudfoundry_environment" {
  count                   = local.cf_env ? 1 : 0
  source                  = "../../../../modules/environment/cloudfoundry/envinstance_cf"
  subaccount_id           = btp_subaccount.subaccount.id
  instance_name           = var.cf_env_instance_name
  cf_org_name             = var.cf_org_name
  cf_org_managers         = var.cf_org_managers
  cf_org_billing_managers = var.cf_org_billing_managers
  cf_org_auditors         = var.cf_org_auditors
}

###
# Create Cloud Foundry space(s) and assign users
###
module "cloudfoundry_space" {
  for_each = {
    for index, space in var.cf_spaces :
    index => space
    if local.cf_env
  }

  source              = "../../../../modules/environment/cloudfoundry/space_cf"
  cf_org_id           = module.cloudfoundry_environment[0].cf_org_id
  name                = each.value.space_name
  cf_space_managers   = each.value.space_managers
  cf_space_developers = each.value.space_developers
  cf_space_auditors   = each.value.space_auditors
}
