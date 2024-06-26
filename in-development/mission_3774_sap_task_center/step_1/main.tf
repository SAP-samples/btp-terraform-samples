###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-3774-${local.random_uuid}", "_", "-"))
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
# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}


######################################################################
# Creation of Cloud Foundry environment
######################################################################
resource "btp_subaccount_environment_instance" "cloudfoundry" {
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

###############################################################################################
# Create the Cloud Foundry space
###############################################################################################
resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

###############################################################################################
# assign user as space manager
###############################################################################################
resource "cloudfoundry_space_role" "cfsr_space_manager" {
  username = var.cfsr_space_manager
  type     = "space_manager"
  space    = cloudfoundry_space.space.id
  origin   = "sap.ids"
}


###############################################################################################
# assign user as space developer
###############################################################################################
resource "cloudfoundry_space_role" "cfsr_space_developer" {
  username = var.cfsr_space_developer
  type     = "space_developer"
  space    = cloudfoundry_space.space.id
  origin   = "sap.ids"
}

###############################################################################################
# Artificial timeout for entitlement propagation to CF Marketplace
###############################################################################################
#resource "time_sleep" "wait_a_few_seconds" {
#  depends_on      = [resource.cloudfoundry_space.space]
#  create_duration = "30s"
#}

###############################################################################################
# Prepare and setup app: SAP Build Workzone, standard edition
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  service_name  = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  amount        = var.service_plan__build_workzone == "free" ? 1 : null
}

# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  app_name      = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}

###############################################################################################
# Prepare and setup app: SAP Task Center
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Task Center
resource "btp_subaccount_entitlement" "taskcenter" {
  subaccount_id = btp_subaccount.project.id
  service_name  = local.service_name__sap_task_center
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as launchpad administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "launchpad-admins" {
  for_each             = toset("${var.launchpad_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone]
}
