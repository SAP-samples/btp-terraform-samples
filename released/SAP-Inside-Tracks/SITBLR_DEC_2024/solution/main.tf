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
}

resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each             = toset(var.emergency_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sapappstudiotrial"
  plan_name     = var.bas_plan_name
}
resource "btp_subaccount_subscription" "bas-subscribe" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "sapappstudiotrial"
  plan_name     = var.bas_plan_name
  depends_on    = [btp_subaccount_entitlement.bas]
}
resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Administrator" {
  for_each             = toset(var.bas_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}

resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Developer" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  for_each             = toset(var.bas_developers)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  landscape_label  = var.cf_landscape_label
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "trial"
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "30m"
  }
}

resource "cloudfoundry_org_role" "my_role" {
  for_each = var.cf_org_user
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

resource "cloudfoundry_space_role" "cf_space_managers" {
  for_each   = toset(var.cf_space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.my_role]
}

resource "cloudfoundry_space_role" "cf_space_developers" {
  for_each   = toset(var.cf_space_developers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.my_role]
}

resource "cloudfoundry_space_role" "cf_space_auditors" {
  for_each   = toset(var.cf_space_auditors)
  username   = each.value
  type       = "space_auditor"
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.my_role]
}
