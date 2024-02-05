# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.0.0"
    }
  }
}

######################################################################
# Create app subscriptions
######################################################################
data "btp_subaccount_subscriptions" "all" {
  subaccount_id = var.btp_subaccount_id
}

resource "btp_subaccount_subscription" "app" {
  subaccount_id = var.btp_subaccount_id
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement if contains(["app"], entitlement.type)
  }
  app_name = [
    for subscription in data.btp_subaccount_subscriptions.all.values :
    subscription
    if subscription.commercial_app_name == each.value.service_name
  ][0].app_name
  plan_name  = each.value.plan_name
  depends_on = [data.btp_subaccount_subscriptions.all]
}

######################################################################
# Assign Role Collection
######################################################################

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.conn_dest_admin)
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "int_prov" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.int_provisioner)
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationAdmin)
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationAdmin)
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationParticipant)
  subaccount_id        = var.btp_subaccount_id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
}

######################################################################
# Create app subscription to SAP Build Apps (depends on entitlement)
######################################################################
module "sap-build-apps_standard" {
  source                   = "../../../modules/services_apps/sap_build_apps/standard"
  subaccount_id            = var.btp_subaccount_id
  subaccount_domain        = var.subdomain
  region                   = var.region
  custom_idp_origin        = var.custom_idp_origin
  users_BuildAppsAdmin     = var.users_BuildAppsAdmin
  users_BuildAppsDeveloper = var.users_BuildAppsDeveloper
  users_RegistryAdmin      = var.users_RegistryAdmin
  users_RegistryDeveloper  = var.users_RegistryDeveloper
}
