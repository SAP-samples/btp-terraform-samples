resource "random_uuid" "uuid" {}

locals {
  subaccount_name        = "${var.subaccount_stage} ${var.project_name}"
  subaccount_description = "Subaccount for Project ${var.project_name} (stage ${var.subaccount_stage})"
  subaccount_subdomain   = join("-", [lower(replace("${var.subaccount_stage}-${var.project_name}", " ", "-")), random_uuid.uuid.result])
  service_name_prefix    = lower(replace("${var.subaccount_stage}-${var.project_name}", " ", "-"))
  subaccount_cf_org      = local.subaccount_subdomain
  cf_space_name          = lower(replace("${var.subaccount_stage}-${var.project_name}", " ", "-"))
  beta_enabled           = var.subaccount_stage == "DEV" ? true : false
  usage                  = var.subaccount_stage == "PROD" ? "USED_FOR_PRODUCTION" : "NOT_USED_FOR_PRODUCTION"
}

resource "btp_subaccount" "project_subaccount" {
  parent_id    = var.parent_id
  name         = local.subaccount_name
  subdomain    = local.subaccount_subdomain
  description  = var.project_name
  region       = var.subaccount_region
  beta_enabled = local.beta_enabled
  usage        = local.usage
  labels = {
    "stage"      = [var.subaccount_stage]
    "costcenter" = [var.project_costcenter]
    "managed_by" = ["terraform"]
    "scope"      = ["integration"]
  }
}

resource "btp_subaccount_role_collection_assignment" "emergency_admins" {
  for_each             = toset(var.emergency_admins)
  subaccount_id        = btp_subaccount.project_subaccount.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}


resource "btp_subaccount_entitlement" "integrationsuite_app_trial" {
  subaccount_id = btp_subaccount.project_subaccount.id
  service_name  = "integrationsuite-trial"
  plan_name     = "trial"
  amount        = 1
}

resource "btp_subaccount_entitlement" "cf_memory" {
  subaccount_id = btp_subaccount.project_subaccount.id
  service_name  = "APPLICATION_RUNTIME"
  plan_name     = "MEMORY"
  amount        = 1
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project_subaccount.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "trial"
  landscape_label  = "cf-${var.cf_landscape_label}"
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
  depends_on = [btp_subaccount_entitlement.cf_memory]
}

locals {
  cf_org_id = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
}

resource "cloudfoundry_org_role" "org_manager" {
  for_each = toset(var.emergency_admins)
  username = each.value
  type     = "organization_user"
  org      = local.cf_org_id
}

resource "cloudfoundry_space" "project_space" {
  name = local.cf_space_name
  org  = local.cf_org_id
}

resource "cloudfoundry_space_role" "emergency_space_manager" {
  for_each   = toset(var.emergency_admins)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.project_space.id
  origin     = "sap.ids"
  depends_on = [cloudfoundry_org_role.org_manager]
}

resource "cloudfoundry_space_role" "space_manager" {
  for_each   = toset(var.space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.project_space.id
  origin     = "sap.ids"
  depends_on = [cloudfoundry_org_role.org_manager]
}

resource "cloudfoundry_space_role" "space_developer" {
  for_each   = toset(var.space_managers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.project_space.id
  origin     = "sap.ids"
  depends_on = [cloudfoundry_org_role.org_manager]
}
