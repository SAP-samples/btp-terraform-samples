###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
locals {
  random_uuid               = uuid()
  project_subaccount_domain = "teched23-tf-sap-ms-${local.random_uuid}"
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

###############################################################################################
# Assignment of users as sub account service administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Creation of Cloud Foundry environment
######################################################################
module "cloudfoundry_environment" {
  source                = "../../modules/environment/cloudfoundry/envinstance_cf/"
  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  plan_name             = "standard"
  cf_org_name = local.project_subaccount_cf_org
  cf_org_auditors       = ["navya.khurana@sap.com"]
  cf_org_managers       = ["navya.khurana@sap.com"]
  cf_org_billing_managers = ["navya.khurana@sap.com"]
}

######################################################################
# Creation of Cloud Foundry space
######################################################################
module "cloudfoundry_space" {
  source              = "../../modules/environment/cloudfoundry/space_cf/"
  cf_org_id           = module.cloudfoundry_environment.cf_org_id
  name                = var.cf_space_name
  cf_space_managers   = var.cf_space_managers
  cf_space_developers = var.cf_space_developers
  cf_space_auditors   = var.cf_space_auditors
}

######################################################################
# Add "sleep" resource for generic purposes
######################################################################
resource "time_sleep" "wait_a_few_seconds" {
  create_duration = "30s"
}

######################################################################
# Entitlement of all services and apps
######################################################################
resource "btp_subaccount_entitlement" "integrationsuite" {
  depends_on = [time_sleep.wait_a_few_seconds]
  subaccount_id = btp_subaccount.project.id
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement if contains(["app"], entitlement.type)
  }
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

######################################################################
# Create service subscriptions
######################################################################
data "btp_subaccount_subscriptions" "all"{
  subaccount_id = btp_subaccount.project.id
  depends_on = [ btp_subaccount_entitlement.integrationsuite ]
}

resource "btp_subaccount_subscription" "app" {

  subaccount_id = btp_subaccount.project.id
  for_each = {
  for index, entitlement in var.entitlements :
  index => entitlement if contains(["app"], entitlement.type)
  }

  app_name   = [
    for subscription in data.btp_subaccount_subscriptions.all.values:subscription
    if subscription.commercial_app_name == each.value.service_name
  ][0].app_name

  plan_name  = each.value.plan_name
  depends_on = [data.btp_subaccount_subscriptions.all, btp_subaccount_entitlement.integrationsuite]
}
