# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
locals {
  random_uuid               = uuid()
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

# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
module "cloudfoundry_environment" {
  source                  = "../../modules/environment/cloudfoundry/envinstance_cf"
  subaccount_id           = btp_subaccount.project.id
  instance_name           = local.project_subaccount_cf_org
  plan_name               = "standard"
  cf_org_name             = local.project_subaccount_cf_org
  cf_org_auditors         = []
  cf_org_billing_managers = []
  cf_org_managers         = []

}

# ------------------------------------------------------------------------------------------------------
# Create service instance - SAP Build Process Automation service
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "bpa" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "process-automation"
  plan_name     = "free"
}

resource "btp_subaccount_subscription" "bpa" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "process-automation"
  plan_name     = "free"
  depends_on    = [btp_subaccount_entitlement.bpa]
}

# Assign users to Role Collection: ProcessAutomationAdmin
resource "btp_subaccount_role_collection_assignment" "bpa_admin" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bpa]
}
