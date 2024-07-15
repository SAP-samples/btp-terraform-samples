

###############################################################################################
# This is the Terraform script for the BTP_200 Learning Journey. In this script you will create
# the infrastructure for the development of an SAP extension project  
# The script will do the following
#   - create a new subaccount (if the subaccount id is not set)
#   - add users as subaccount administrators and viewers
#   - create entitlements for the following services:
#        * SAP Business Application Studio
#        * SAP Continous & Integration Application
#        * SAP Build Workzone - standard edition
#   - create subscriptions
#   - add user to service role collections
###############################################################################################

###############################################################################################
# Setup subaccount domain and the CF org (to ensure uniqueness in BTP global account)
###############################################################################################
locals {
  project_subaccount_domain = lower("${var.subaccount_name}-${var.org}")
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}


###############################################################################################
# Creation of subaccount - if subaccount_id = ""
###############################################################################################
resource "btp_subaccount" "create_subaccount" {
  count = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

# For the next resources we need the subaccount ID – either use the new one or one from the subaccount_id variable
data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.create_subaccount[0].id
}

##############################################################################################
# Assign users to the subaccount role collections
##############################################################################################
# Assignment of admins to the sub account as sub account administrators
resource "btp_subaccount_role_collection_assignment" "subaccount_admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# Assignment of developers to the sub account as sub account viewer
resource "btp_subaccount_role_collection_assignment" "subaccount_viewer" {
  for_each             = toset("${var.developers}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Viewer"
  user_name            = each.value
}
# Assignment of the subaccount service administrators 
resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin" {
  for_each             = toset("${var.service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

##############################################################################################
# Creating entitlements
##############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = var.build_workzone_service_plan
}

# Entitle subaccount for usage of app  destination SAP Business Application Studio
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = var.bas_service_plan
}
# Entitle subaccount for usage of app  destination Continous Integration & Delivery
resource "btp_subaccount_entitlement" "cicd" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "cicd-app"
  plan_name     = var.cicd_service_plan
}

##############################################################################################
# Creating subscriptions
##############################################################################################
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = var.build_workzone_service_plan
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}

# Create app subscription to SAP Business Application Studio (depends on entitlement)
resource "btp_subaccount_subscription" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "sapappstudio"
  plan_name     = var.bas_service_plan
  depends_on    = [btp_subaccount_entitlement.bas]
}
# Create app subscription to SAP Business Application Studio (depends on entitlement)
resource "btp_subaccount_subscription" "cicd" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "cicd-app"
  plan_name     = var.cicd_service_plan
  depends_on    = [btp_subaccount_entitlement.cicd]
}

###############################################################################################
# Assign User to role collections
###############################################################################################


# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone]
}

# Assign users to Role Collection: Business_Application_Studio_Administrator
resource "btp_subaccount_role_collection_assignment" "bas_admin" {
  for_each             = toset("${var.service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}

# Assign users to Role Collection: Business_Application_Studio_Developer
resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  for_each             = toset("${var.developers}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}

# Assign users to Role Collection: CICD Service Administrator
resource "btp_subaccount_role_collection_assignment" "cicd_admin" {
  for_each             = toset("${var.service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd]
}

# Assign users to Role Collection: CICD Service Developer
resource "btp_subaccount_role_collection_assignment" "cicd_dev" {
  for_each             = toset("${var.developers}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd]
}
