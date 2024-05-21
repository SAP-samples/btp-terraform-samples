locals {
  project_subaccount_name   = "${var.org_name} | ${var.project_name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.project_name}-${var.stage}", " ", ""))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.project_name)}-${lower(var.stage)}", " ", "_")
}

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

resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each             = toset(var.emergency_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

resource "btp_subaccount_entitlement" "entitlements" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }

  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.name
  plan_name     = each.value.plan
}

resource "btp_subaccount_subscription" "subscriptions" {
  for_each = {
    for index, subscription in var.subscriptions :
    index => subscription
  }

  subaccount_id = btp_subaccount.project.id
  app_name      = each.value.app_name
  plan_name     = each.value.plan
  depends_on    = [btp_subaccount_entitlement.entitlements]
}

data "btp_subaccount_service_plan" "alert_notification_standard_plan" {
  subaccount_id = btp_subaccount.project.id
  name          = "standard"
  offering_name = "alert-notification"
  depends_on    = [btp_subaccount_entitlement.entitlements]
}

resource "btp_subaccount_service_instance" "alert_notification_standard" {
  name           = "alert-notification"
  serviceplan_id = data.btp_subaccount_service_plan.alert_notification_standard_plan.id
  subaccount_id  = btp_subaccount.project.id
}

module "cloudfoundry_environment" {
  source = "../modules/environment/cloudfoundry/envinstance_cf"

  subaccount_id           = btp_subaccount.project.id
  instance_name           = local.project_subaccount_cf_org
  cf_org_name             = local.project_subaccount_cf_org
  plan_name               = "trial"
  cf_org_managers         = []
  cf_org_billing_managers = []
  cf_org_auditors         = []
}

module "cloudfoundry_space" {
  source = "../modules/environment/cloudfoundry/space_cf"

  cf_org_id           = module.cloudfoundry_environment.cf_org_id
  name                = var.cf_space_name
  cf_space_managers   = []
  cf_space_developers = []
  cf_space_auditors   = []
}
