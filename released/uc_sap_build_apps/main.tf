###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
locals {
  project_subaccount_name   = "My SAP Build Apps 2"
  project_subaccount_domain = "build-apps-20230728"
  project_subaccount_cf_org = local.project_subaccount_domain
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage = "USED_FOR_PRODUCTION"
}

###############################################################################################
# Assignment of emergency admins to the sub account as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each = toset("${var.emergency_admins}")
    subaccount_id        = btp_subaccount.project.id
    role_collection_name = "Subaccount Administrator"
    user_name     = each.value
}

###############################################################################################
# Assign custom IDP to sub account
###############################################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
}

###############################################################################################
# Creation of Cloud Foundry environment
###############################################################################################
module "cloudfoundry_environment" {
  source = "github.com/SAP-samples/btp-terraform-samples/released/modules/envinstance-cloudfoundry/"
  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  cloudfoundry_org_name = local.project_subaccount_cf_org
}

###############################################################################################
# Prepare and setup service: destination
###############################################################################################
# Entitle subaccount for usage of service destination
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "destination"
  plan_name     = "lite"
}

###############################################################################################
# Prepare and setup app: SAP Build Apps
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "sap_build_apps" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sap-build-apps"
  plan_name     = "standard"
}
# Create app subscription to SAP Build Apps (depends on entitlement)
module "sap-build-apps_standard" {
    source                    = "../modules/sap_build_apps/standard"
    subaccount_id             = btp_subaccount.project.id
    subaccount_domain         = btp_subaccount.project.subdomain
    region                    = var.region
    custom_idp                = var.custom_idp
    users_BuildAppsAdmin      = var.emergency_admins
    users_BuildAppsDeveloper  = var.emergency_admins
    users_RegistryAdmin       = var.emergency_admins
    users_RegistryDeveloper   = var.emergency_admins
    depends_on                = [btp_subaccount_entitlement.sap_build_apps]
}

###############################################################################################
# Prepare and setup app: SAP Build Workzone, standard edition
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each = toset("${var.emergency_admins}")
    subaccount_id        = btp_subaccount.project.id
    role_collection_name = "Launchpad_Admin"
    user_name            = each.value  
    depends_on           = [btp_subaccount_subscription.build_workzone]
}
