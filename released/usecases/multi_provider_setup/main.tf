###
# Create SAP BTP subaccount for default use caee
###
resource "btp_subaccount" "subaccount" {
  name      = var.subacount_name
  subdomain = var.subacount_subdomain
  region    = var.region
}

###
# Add the entitlements to the subaccount
###
resource "btp_subaccount_entitlement" "entitlement-taskcenter" {
  subaccount_id = btp_subaccount.subaccount.id
  for_each      = var.entitlements
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

###
# Create Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "../../modules/btp-cf/btp-cf-org-space"
  subaccount_id           = btp_subaccount.subaccount.id
  instance_name           = var.cloudfoundry_org_name
  cf_org_name             = var.cloudfoundry_org_name
  cf_org_admins           = var.cf_org_admins
  cf_org_managers         = var.cf_org_admins
  cf_org_billing_managers = []
  cf_org_auditors         = []
  space_name              = var.space_name
  cf_org_id               = module.cloudfoundry_environment.cf_org_id
  cf_space_managers       = var.cf_space_managers
  cf_space_developers     = var.cf_space_developers
  origin                  = var.origin
}

###
# Assign the subaccount roles to the users
resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  subaccount_id        = btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Administrator"
  for_each             = var.subaccount_admins
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "subaccount-service-administrators" {
  subaccount_id        = btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Service Administrator"
  for_each             = var.subaccount_service_admins
  user_name            = each.value
}
