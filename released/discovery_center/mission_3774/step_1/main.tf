###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-3774-${local.random_uuid}", "_", "-"))
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}
###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}
# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}
# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}


# ------------------------------------------------------------------------------------------------------
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "replacement" {
  input = length(var.cf_environment_label) > 0 ? var.cf_environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = local.project_subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.replacement.output
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
}
###############################################################################################
# Prepare and setup app: SAP Build Workzone, standard edition
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  amount        = var.service_plan__build_workzone == "free" ? 1 : null
}
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}
###############################################################################################
# Prepare and setup app: SAP Task Center
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Task Center
resource "btp_subaccount_entitlement" "taskcenter" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_task_center
  plan_name     = "standard"
}
# ------------------------------------------------------------------------------------------------------
# Assignment of users as launchpad administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "launchpad-admins" {
  for_each             = toset("${var.launchpad_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone]
}
