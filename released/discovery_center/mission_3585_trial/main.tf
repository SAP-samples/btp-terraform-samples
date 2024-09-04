# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 3585
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count     = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = join("-", ["dc-mission-3585", random_uuid.uuid.result])
  region    = lower(var.region)
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__sap_launchpad = "SAPLaunchpad"
  # optional
  service_name__cicd_app = "cicd-app"
}

# ------------------------------------------------------------------------------------------------------
# Setup SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  amount        = var.service_plan__sap_launchpad == "free" ? 1 : null
}
# Subscribe
resource "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
}
data "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  depends_on    = [btp_subaccount_subscription.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
# Setup cicd-app (Continuous Integration & Delivery)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "cicd_app" {
  count         = var.use_optional_resources ? 1 : 0
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__cicd_app
  plan_name     = var.service_plan__cicd_app
  amount        = var.service_plan__cicd_app == "free" ? 1 : null
}
# Subscribe
resource "btp_subaccount_subscription" "cicd_app" {
  count         = var.use_optional_resources ? 1 : 0
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__cicd_app
  plan_name     = var.service_plan__cicd_app
  depends_on    = [btp_subaccount_entitlement.cicd_app]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount.dc_mission]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Launchpad_Admin"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.launchpad_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "CICD Service Administrator"
# ------------------------------------------------------------------------------------------------------
# optional app subscription

resource "btp_subaccount_role_collection_assignment" "cicd_admins" {
  for_each             = toset(var.use_optional_resources == true ? var.cicd_admins : [])
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "CICD Service Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd_app]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "CICD Service Developer"
# ------------------------------------------------------------------------------------------------------
# optional app subscription
resource "btp_subaccount_role_collection_assignment" "cicd_developers" {
  for_each             = toset(var.use_optional_resources == true ? var.cicd_developers : [])
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "CICD Service Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd_app]
}