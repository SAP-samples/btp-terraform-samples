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
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = btp_subaccount.project.id
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
# Entitlement of all services and apps
######################################################################
resource "btp_subaccount_entitlement" "name" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

######################################################################
# Create service instances (and service keys when needed)
######################################################################
# hana plan id
data "btp_subaccount_service_plan" "hana_plan" {
  subaccount_id = btp_subaccount.project.id
  name          = "hana"
  offering_name = "hana-cloud"
  depends_on    = [btp_subaccount_entitlement.name]
}

# hana-cloud
resource "btp_subaccount_service_instance" "hana_instance" {
  depends_on     = [data.btp_subaccount_service_plan.hana_plan]
  name           = "hana_cloud_instance"
  serviceplan_id = data.btp_subaccount_service_plan.hana_plan.id
  subaccount_id  = btp_subaccount.project.id
  parameters     = jsonencode({ "data" : { "memory" : 32, "edition" : "cloud", "systempassword" : "Abcd1234", "whitelistIPs" : ["0.0.0.0/0"] } })
}

######################################################################
# Assign custom IDP to sub account
######################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
}

######################################################################
# Create app subscriptions
######################################################################
data "btp_subaccount_subscriptions" "all" {
  subaccount_id = btp_subaccount.project.id
  depends_on    = [btp_subaccount_entitlement.name]
}

resource "btp_subaccount_subscription" "app" {
  subaccount_id = btp_subaccount.project.id
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
  depends_on = [data.btp_subaccount_subscriptions.all, btp_subaccount_trust_configuration.fully_customized]
}

######################################################################
# Role Collections
######################################################################
resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.appstudio_developers)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "bas_admn" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.appstudio_admin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "cloud_conn_admn" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.cloudconnector_admin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.conn_dest_admin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}

######################################################################
# Advanced Event Mesh
######################################################################
resource "btp_subaccount_entitlement" "aem" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "integration-suite-advanced-event-mesh"
  plan_name     = "default"
}

resource "btp_subaccount_subscription" "aem_app" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "integration-suite-advanced-event-mesh"
  plan_name     = "default"
  parameters = jsonencode({
    "admin_user_email" : var.advanced_event_mesh_admin
  })
  depends_on = [btp_subaccount_entitlement.aem]
}

