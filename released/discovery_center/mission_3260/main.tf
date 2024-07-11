# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-3260-${local.random_uuid}", "_", "-"))
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
# Add Entitlement & Create Subscription - SAP Build Process Automation service
# ------------------------------------------------------------------------------------------------------

# Add Entitlement
resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}

# Create app subscription to SAP Build Process Automation
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}

# ------------------------------------------------------------------------------------------------------
# Assign Roles - SAP Build Process Automation service
# ------------------------------------------------------------------------------------------------------

# Assign users to Role Collection: ProcessAutomationAdmin
resource "btp_subaccount_role_collection_assignment" "bpa_admins" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_participants" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_participants)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_developers" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = each.value
}