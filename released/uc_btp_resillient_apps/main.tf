###
# Setup of names in accordance to naming convention
###
locals {
  random_uuid = uuid()  
  project_subaccount_domain = "teched23-tf-sap-ms-${local.random_uuid}"
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
# Creation of Cloud Foundry space
######################################################################
module "cloudfoundry_space" {
  source              = "../modules/cloudfoundry-space/"
  cf_org_id           = module.cloudfoundry_environment.org_id
  name                = var.cf_space_name
  cf_space_managers   = var.cf_space_managers
  cf_space_developers = var.cf_space_developers
  cf_space_auditors   = var.cf_space_auditors
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
  source        = "./modules/cf-service-setup/"
  subaccount_id = btp_subaccount.project.id
  cf_space_id   = module.cloudfoundry_space.id

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["service"], entitlement.type)
 }
    name        = each.value.service_name
    plan        = each.value.plan_name
    parameters  = each.value.parameters
}
