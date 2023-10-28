###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
locals {
  random_uuid               = uuid()
  project_subaccount_domain = "btp-developers-guide${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}
###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}
###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}
######################################################################
# Creation of Cloud Foundry environment
######################################################################
module "cloudfoundry_environment" {
  source                    = "../../../modules/environment/cloudfoundry/envinstance_cf"
  subaccount_id             = btp_subaccount.project.id
  instance_name             = local.project_subaccount_cf_org
  plan_name                 = "standard"
  cf_org_name               = local.project_subaccount_cf_org
  cf_org_auditors           = var.cf_org_auditors
  cf_org_managers           = var.cf_org_managers
  cf_org_billing_managers   = var.cf_org_billing_managers
}
######################################################################
# Add "sleep" resource for generic purposes
######################################################################
resource "time_sleep" "wait_a_few_seconds" {
  create_duration = "30s"
}

######################################################################
# Add entitlement for BAS, Subscribe BAS and add roles
######################################################################
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = var.bas_plan_name
}
resource "btp_subaccount_subscription" "bas-subscribe" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "sapappstudio"
  plan_name     = var.bas_plan_name
  depends_on    = [btp_subaccount_entitlement.bas]
}
resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Administrator" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}
resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Developer" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}
######################################################################
# Add Build Workzone entitlement subscription and role Assignment
######################################################################
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = var.build_workzone_plan_name
}
resource "btp_subaccount_subscription" "build_workzone_subscribe" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = var.build_workzone_plan_name
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.build_workzone_subscribe]
}
######################################################################
# Create HANA entitlement subscription
######################################################################
resource "btp_subaccount_entitlement" "hana-cloud" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana-cloud"
  plan_name        = var.hana-cloud_plan_name
}
# Enable HANA Cloud Tools
resource "btp_subaccount_entitlement" "hana-cloud-tools" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana-cloud-tools"
  plan_name        = "tools"
}
resource "btp_subaccount_subscription" "hana-cloud-tools" {
  subaccount_id    = btp_subaccount.project.id
  app_name         = "hana-cloud-tools"
  plan_name        = "tools"
  depends_on       = [btp_subaccount_entitlement.hana-cloud-tools]
}
resource "btp_subaccount_entitlement" "hana-hdi-shared" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana"
  plan_name        = "hdi-shared"
}
