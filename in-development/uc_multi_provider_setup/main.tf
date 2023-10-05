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
  source                = "../modules/envinstance-cloudfoundry/"
  subaccount_id         = btp_subaccount.subaccount.id
  instance_name         = var.cloudfoundry_org_name
  cloudfoundry_org_name = var.cloudfoundry_org_name
}

###
# Create Cloud Foundry space and assign users
###
module "cloudfoundry_space" {
  source              = "../modules/cloudfoundry-space/"
  cf_org_id           = module.cloudfoundry_environment.org_id
  name                = var.cloudfoundry_space_name
  cf_space_managers   = var.cloudfoundry_space_managers
  cf_space_developers = var.cloudfoundry_space_developers
  cf_space_auditors   = var.cloudfoundry_space_auditors
}

###
# Assign the subaccount roles to the users
###
resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  subaccount_id        = btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Administrator"
  for_each             = var.subaccount_admins
  user_name            = each.value
  depends_on = [
    btp_subaccount.subaccount
  ]
}

resource "btp_subaccount_role_collection_assignment" "subaccount-service-administrators" {
  subaccount_id        = btp_subaccount.subaccount.id
  role_collection_name = "Subaccount Service Administrator"
  for_each             = var.subaccount_service_admins
  user_name            = each.value
  depends_on = [
    btp_subaccount.subaccount
  ]
}
