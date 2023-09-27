locals {
  stage2space_map = tomap({
    DEV = "dev"
    TST = "qa"
    PRD = "prod"
    POC = "dev"
  })
  multiple_subaccounts = length(tomap(var.subaccounts)) > 1
}

###
# Create a directory if there are multiple subaccounts configured
###
resource "btp_directory" "directory" {
  count = local.multiple_subaccounts ? 1 : 0
  name  = var.project_name
}

###
# Call module for creating subaccount
###
module "subaccount_setup" {
  for_each             = tomap(var.subaccounts)
  source               = "./modules/subaccount_setup"
  subaccount_name      = "${var.project_name}_${each.key}"
  subaccount_subdomain = lower("${var.project_name}${each.key}")
  region               = var.region
  parent_directory_id  = local.multiple_subaccounts ? btp_directory.directory[0].id : null
  subaccount_labels    = each.value.labels
  entitlements         = each.value.entitlements
  subscriptions        = each.value.subscriptions
  role_collection_assignments = flatten([
    for index, role_collection_assignment in each.value.role_collection_assignments : [
      for index, user in role_collection_assignment.users : {
        role_collection_name = role_collection_assignment.role_collection_name
        user                 = user
      }
    ]
  ])
  cf_env_instance_name    = each.value.cf_environment_instance != null ? lower("${var.project_name}${lookup(local.stage2space_map, each.key, "dev")}") : ""
  cf_org_name             = each.value.cf_environment_instance != null ? lower("${var.project_name}${lookup(local.stage2space_map, each.key, "dev")}") : ""
  cf_org_managers         = each.value.cf_environment_instance != null ? each.value.cf_environment_instance.org_managers : []
  cf_org_billing_managers = each.value.cf_environment_instance != null ? each.value.cf_environment_instance.org_billing_managers : []
  cf_org_auditors         = each.value.cf_environment_instance != null ? each.value.cf_environment_instance.org_auditors : []
  cf_spaces               = each.value.cf_environment_instance != null ? each.value.cf_environment_instance.spaces : []
}

