# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-3348-${local.random_uuid}", "_", "-"))
}

locals {
  service_name__sap_analytics_cloud = "analytics-planning-osb"
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

locals {
  custom_idp_tenant    = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key           = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : "sap.default"
  origin_key_app_users = var.custom_idp != "" ? var.custom_idp_apps_origin_key : "sap.default"
}

# -


# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  origin               = local.origin_key
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  origin               = local.origin_key
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Setup SAP Analytics Cloud (not running in CF environment)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "sac" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_analytics_cloud
  plan_name     = var.service_plan__sap_analytics_cloud
}
# Get serviceplan_id for data-analytics-osb with plan_name "standard"
data "btp_subaccount_service_plan" "sac" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  offering_name = local.service_name__sap_analytics_cloud
  name          = var.service_plan__sap_analytics_cloud
  depends_on    = [btp_subaccount_entitlement.sac]
}

# Create service instance
resource "btp_subaccount_service_instance" "sac" {
  subaccount_id  = data.btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.sac.id
  name           = "sac_instance"
  parameters = jsonencode(
    {
      "first_name" : "${var.sac_admin_first_name}",
      "last_name" : "${var.sac_admin_last_name}",
      "email" : "${var.sac_admin_email}",
      "confirm_email" : "${var.sac_admin_email}",
      "host_name" : "${var.sac_admin_host_name}",
      "number_of_business_intelligence_licenses" : var.sac_number_of_business_intelligence_licenses,
      "number_of_planning_professional_licenses" : var.sac_number_of_professional_licenses,
      "number_of_planning_standard_licenses" : var.sac_number_of_business_standard_licenses
    }
  )
  timeouts = {
    create = "90m"
    update = "90m"
    delete = "90m"
  }
}