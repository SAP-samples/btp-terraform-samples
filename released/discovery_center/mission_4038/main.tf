# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-4038-${local.random_uuid}", "_", "-"))
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count     = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account (if custom_idp is set)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  # Only create trust configuration if custom_idp has been set 
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = data.btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp
}


# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Setup data-analytics-osb (not running in CF environment)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "datasphere" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_datasphere
  plan_name     = var.service_plan__sap_datasphere
}
# Get serviceplan_id for data-analytics-osb with plan_name "standard"
data "btp_subaccount_service_plan" "datasphere" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  offering_name = local.service_name__sap_datasphere
  name          = var.service_plan__sap_datasphere
  depends_on    = [btp_subaccount_entitlement.datasphere]
}

# Create service instance
resource "btp_subaccount_service_instance" "datasphere" {
  subaccount_id  = data.btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.datasphere.id
  name           = "datasphere_instance"
  parameters = jsonencode(
    {
      "first_name" : "${var.datasphere_admin_first_name}",
      "last_name" : "${var.datasphere_admin_last_name}",
      "email" : "${var.datasphere_admin_email}",
      "host_name" : "${var.datasphere_admin_host_name}",
    }
  )
  timeouts = {
    create = "90m"
    update = "90m"
    delete = "90m"
  }
}

# ------------------------------------------------------------------------------------------------------
# Create app subscription to SAP Integration Suite
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_integration_suite
  plan_name     = var.service_plan__sap_integration_suite
  amount        = var.service_plan__sap_integration_suite == "free" ? 1 : null
}

data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_entitlement.sap_integration_suite]
}

resource "btp_subaccount_subscription" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name = [
    for subscription in data.btp_subaccount_subscriptions.all.values :
    subscription
    if subscription.commercial_app_name == local.service_name__sap_integration_suite
  ][0].app_name
  plan_name  = var.service_plan__sap_integration_suite
  depends_on = [data.btp_subaccount_subscriptions.all]
}

resource "btp_subaccount_role_collection_assignment" "int_prov" {
  depends_on           = [btp_subaccount_subscription.sap_integration_suite]
  for_each             = toset(var.int_provisioners)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
}

