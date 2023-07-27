###
# Setup of names in accordance to naming convention
###
locals {
  project_subaccount_name   = "My SAP Build Apps 2"
  project_subaccount_domain = "build-apps-20230727"
  project_subaccount_cf_org = local.project_subaccount_domain
}

###
# Creation of subaccount
###
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage = "USED_FOR_PRODUCTION"

}

###
# Assignment of emergency admins to the sub account as sub account administrators
###
resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each = toset("${var.emergency_admins}")
    subaccount_id        = btp_subaccount.project.id
    role_collection_name = "Subaccount Administrator"
    user_name     = each.value
}

resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
}

###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "github.com/SAP-samples/btp-terraform-samples/released/modules/envinstance-cloudfoundry/"

  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  cloudfoundry_org_name = local.project_subaccount_cf_org
}

resource "btp_subaccount_entitlement" "entitlements" {

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement
  }

  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.name
  plan_name     = each.value.plan
}

/*
resource "btp_subaccount_subscription" "subscriptions" {

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement
    if entitlement.type == "subscription"
  }

  subaccount_id = btp_subaccount.project.id
  app_name      = each.value.name
  plan_name     = each.value.plan
}
*/


###
# Call module for creating SAP Build Apps with plan "standard"
###
module "sap-build-apps_standard" {
  
    source              = "../modules/sap_build_apps/standard"
    subaccount_id = btp_subaccount.project.id
    depends_on = [btp_subaccount_entitlement.entitlements]
}