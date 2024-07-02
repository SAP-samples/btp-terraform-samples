###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-4172-${local.random_uuid}", "_", "-"))
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.project[0].id
}

###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

###############################################################################################
# Assignment of users as sub account service administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Creation of Cloud Foundry environment
######################################################################
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = data.btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = var.cf_environment_label
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
}

######################################################################
# Entitlement of all general services
######################################################################
resource "btp_subaccount_entitlement" "genentitlements" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = data.btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

######################################################################
# Create app subscription to SAP Integration Suite
######################################################################
resource "btp_subaccount_entitlement" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__sap_integration_suite
  plan_name     = var.service_plan__sap_integration_suite
}

data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.project.id
  depends_on = [ btp_subaccount_entitlement.sap_integration_suite ]
}

resource "btp_subaccount_subscription" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.project.id
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
  for_each             = toset(var.int_provisioner)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
}

# ######################################################################
# # Create app subscription to SAP Business APplication Studio
# ######################################################################

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
}

# Create app subscription to busineass applicaiton stuido
resource "btp_subaccount_subscription" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_developers)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "bas_admn" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_admin)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
}

######################################################################
# Assign Role Collection
######################################################################

resource "btp_subaccount_role_collection_assignment" "cloud_conn_admn" {
  depends_on           = [btp_subaccount_entitlement.genentitlements]
  for_each             = toset(var.cloudconnector_admin)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_entitlement.genentitlements]
  for_each             = toset(var.conn_dest_admin)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}
