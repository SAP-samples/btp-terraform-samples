###
# Setup of names in accordance to naming convention
###
locals {
  random_uuid = uuid()  
  project_subaccount_domain = "ucresilientapps${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""),0,32)
}

######################################################################
# Creation of subaccount
######################################################################
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

######################################################################
# Creation of Cloud Foundry environment
######################################################################
module "cloudfoundry_environment" {
  source = "../modules/envinstance-cloudfoundry/"
  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  plan_name             = "standard"
  cloudfoundry_org_name = local.project_subaccount_cf_org
}


######################################################################
# Entitle and create app subscriptions
######################################################################
module "app_subscription" {
  source        = "./modules/app-subscription/"
  subaccount_id = btp_subaccount.project.id

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["app"], entitlement.type)
 }
    name     = each.value.service_name
    plan     = each.value.plan_name
}

######################################################################
# Entitle and create service instances
######################################################################
module "service_instances" {
  source        = "./modules/cf-service-instance/"
  subaccount_id = btp_subaccount.project.id

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["service"], entitlement.type)
 }
    name        = each.value.service_name
    plan        = each.value.plan_name
    parameters  = each.value.parameters
    cf_org_id   = var.cf_org_id
}


/*
######################################################################
# Entitlements for subaccount
######################################################################
# Connectivity - lite
resource "btp_subaccount_entitlement" "connectivity" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "connectivity"
  plan_name     = "lite"
}
# Destination - lite
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "destination"
  plan_name     = "lite"
}
# html5-apps-repo
resource "btp_subaccount_entitlement" "html5-apps-repo" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "html5-apps-repo"
  plan_name     = "app-host"
}
# Enterprise-messaging - default
resource "btp_subaccount_entitlement" "enterprise-messaging" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "enterprise-messaging"
  plan_name     = "default"
}
# Application-logs - lite
resource "btp_subaccount_entitlement" "application-logs" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "application-logs"
  plan_name     = "lite"
}
#XSUAA - application
resource "btp_subaccount_entitlement" "xsuaa" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "xsuaa"
  plan_name     = "application"
}
# Hana - hdi-shared
resource "btp_subaccount_entitlement" "hana" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "hana"
  plan_name     = "hdi-shared"
}
# Hana-cloud - hana
resource "btp_subaccount_entitlement" "hana-cloud" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}
# Autoscaler - standard
resource "btp_subaccount_entitlement" "autoscaler" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "autoscaler"
  plan_name     = "standard"
}
# sapappstudio - standard-edition
resource "btp_subaccount_entitlement" "sapappstudio" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = "standard-edition"
}
# enterprise-messaging-hub - standard-edition
resource "btp_subaccount_entitlement" "enterprise-messaging-hub" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "enterprise-messaging-hub"
  plan_name     = "standard"
}
# SAPLaunchpad - standard
resource "btp_subaccount_entitlement" "SAPLaunchpad" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}
# cicd-app - default
resource "btp_subaccount_entitlement" "cicd-app" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "cicd-app"
  plan_name     = "default"
}
# alm-ts - standard
resource "btp_subaccount_entitlement" "alm-ts" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "alm-ts"
  plan_name     = "standard"
}

######################################################################
# Create app subscriptions
######################################################################
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "sapappstudio" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.sapappstudio]
}
*/