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
  source = "../../modules/envinstance-cloudfoundry/"
  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  plan_name             = "standard"
  cloudfoundry_org_name = local.project_subaccount_cf_org
}

######################################################################
# Entitle and create app subscriptions
######################################################################
module "app_subscription" {
  source        = "../modules/app-subscription/"
  subaccount_id = btp_subaccount.project.id

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["app"], entitlement.type)
 }
    name     = each.value.service_name
    plan     = each.value.plan_name
}

######################################################################
# Entitle services
######################################################################
resource "btp_subaccount_entitlement" "services" {
  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["service"], entitlement.type)
 }
    subaccount_id = btp_subaccount.project.id
    service_name  = each.value.service_name
    plan_name     = each.value.plan_name
}
