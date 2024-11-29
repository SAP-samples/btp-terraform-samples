###
# Setup of names in accordance to the company's naming conventions
###
locals {
  project_subaccount_name   = "${var.org_name} | ${var.project_name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.project_name}-${var.stage}", " ", "-"))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.project_name)}-${lower(var.stage)}", " ", "_")
}

###
# Creation of subaccount
###
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  labels = {
    "stage"      = ["${var.stage}"],
    "costcenter" = ["${var.costcenter}"]
  }
  usage = "NOT_USED_FOR_PRODUCTION"
}

###
# Entitlement Subscription and Role Assignment for BAS
###

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.project.id
  service_name  = var.bas_service_name
  plan_name     = var.bas_plan
}

resource "btp_subaccount_subscription" "bas" {
  subaccount_id = btp_subaccount.project.id
  app_name      = var.bas_service_name
  plan_name     = var.bas_plan
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_admin" {
  for_each             = toset(var.bas_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_developer" {
  for_each             = toset(var.bas_developers)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}