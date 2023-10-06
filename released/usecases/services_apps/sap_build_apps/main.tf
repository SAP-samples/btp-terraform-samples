# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain and the CF org (to ensure uniqueness in BTP global account)
# ------------------------------------------------------------------------------------------------------
locals {
  random_uuid               = uuid()
  project_subaccount_domain = "buildapps${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

# ------------------------------------------------------------------------------------------------------
# Assignment of emergency admins to the sub account as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each             = toset("${var.emergency_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: SAP Build Apps
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "sap_build_apps" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sap-build-apps"
  plan_name     = "standard"
  amount        = 1
}
# Create app subscription to SAP Build Apps (depends on entitlement)
module "sap-build-apps_standard" {

  source            = "../../../modules/services_apps/sap_build_apps/standard"
  subaccount_id     = btp_subaccount.project.id
  subaccount_domain = btp_subaccount.project.subdomain
  region            = var.region
  custom_idp_origin = btp_subaccount_trust_configuration.fully_customized.origin

  users_BuildAppsAdmin     = var.users_BuildAppsAdmin
  users_BuildAppsDeveloper = var.users_BuildAppsDeveloper
  users_RegistryAdmin      = var.users_RegistryAdmin
  users_RegistryDeveloper  = var.users_RegistryDeveloper
  depends_on               = [btp_subaccount_entitlement.sap_build_apps, btp_subaccount_trust_configuration.fully_customized]
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of service destination
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "destination"
  plan_name     = "lite"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: SAP Build Workzone, standard edition
# ------------------------------------------------------------------------------------------------------
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
  depends_on    = [btp_subaccount_entitlement.build_workzone, btp_subaccount_trust_configuration.fully_customized]
}
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.emergency_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone]
}
