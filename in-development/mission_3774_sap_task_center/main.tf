# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = "discoverycenter-tf-sap-ms-${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
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

###############################################################################################
# Creates a cloud foundry environment in a given account
###############################################################################################
// and the dedicted target landscape cf-us10
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project.id
  name             = var.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  landscape_label  = null_resource.cache_target_environment.triggers.label
  plan_name        = "standard"
  parameters = jsonencode({
    instance_name = var.cf_org_name
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
resource "time_sleep" "wait_a_few_seconds" {
  depends_on      = [resource.cloudfoundry_space.space]
  create_duration = "30s"
}

###############################################################################################
# Prepare and setup app: SAP Build Workzone, standard edition
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  amount        = var.service_plan__build_workzone == "free" ? 1 : null
}

# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service_name__build_workzone
  plan_name     = var.service_plan__build_workzone
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}

###############################################################################################
# Prepare and setup app: SAP Task Center
###############################################################################################

// Create service instance for taskcenter (one-inbox-service)
data "cloudfoundry_service" "srvc_taskcenter" {
  name       = "one-inbox-service"
  depends_on = [time_sleep.wait_a_few_seconds]
}

resource "cloudfoundry_service_instance" "si_taskcenter" {
  name         = "sap-taskcenter"
  type         = "managed"
  space        = cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.srvc_taskcenter.service_plans["standard"]
  depends_on   = [cloudfoundry_space_role.cfsr_space_admin, cloudfoundry_space_role.cfsr_space_developer]
  parameters = jsonencode({
	              "authorities": [],
                "defaultCollectionQueryFilter": "own"

  })
}