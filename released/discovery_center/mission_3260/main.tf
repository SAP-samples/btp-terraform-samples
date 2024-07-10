# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "discoverycenter-tf-sap-ms-${local.random_uuid}"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
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
# Create service instance - SAP Build Process Automation service
# ------------------------------------------------------------------------------------------------------
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

resource "btp_subaccount_role_collection_assignment" "sbpa_admins" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_developers" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
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