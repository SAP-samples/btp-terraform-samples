# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 3260
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-3260-${local.random_uuid}", "_", "-"))
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count     = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account (if custom_idp is set)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  # Only create trust configuration if custom_idp has been set 
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = data.btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__cloudfoundry = "cloudfoundry"
}

# ------------------------------------------------------------------------------------------------------
# Setup cloudfoundry (Cloud Foundry Environment)
# ------------------------------------------------------------------------------------------------------
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
}
# Take the landscape label from the first CF environment if no environment label is provided (this replaces the previous null_resource)
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# Create instance
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = data.btp_subaccount.dc_mission.id
  name             = "cf-${random_uuid.uuid.result}"
  environment_type = "cloudfoundry"
  service_name     = local.service_name__cloudfoundry
  plan_name        = var.service_plan__cloudfoundry
  landscape_label  = terraform_data.cf_landscape_label.output

  parameters = jsonencode({
    instance_name = "cf-${random_uuid.uuid.result}"
  })
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__sap_process_automation = "process-automation"
}
# ------------------------------------------------------------------------------------------------------
# Setup process-automation (SAP Build Process Automation)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}
# Subscribe
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}
# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
data "btp_whoami" "me" {}
#
locals {
  subaccount_admins         = var.subaccount_admins
  subaccount_service_admins = var.subaccount_service_admins

  process_automation_admins       = var.process_automation_admins
  process_automation_developers   = var.process_automation_developers
  process_automation_participants = var.process_automation_participants

  custom_idp_tenant = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : ""
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${local.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount.dc_mission]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Service Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin" {
  for_each             = toset("${local.subaccount_service_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount.dc_mission]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "ProcessAutomationAdmin"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "process_automation_admins" {
  for_each             = toset(local.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
  origin               = var.custom_idp_apps_origin_key
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}

# Assign logged in user to the role collection "ProcessAutomationAdmin" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "process_automation_admins_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "ProcessAutomationDeveloper"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "process_automation_developers" {
  for_each             = toset(local.process_automation_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = each.value
  origin               = var.custom_idp_apps_origin_key
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}

# Assign logged in user to the role collection "ProcessAutomationDeveloper" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "process_automation_developers_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "ProcessAutomationParticipant"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "process_automation_participants" {
  for_each             = toset(local.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
  origin               = var.custom_idp_apps_origin_key
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}

# Assign logged in user to the role collection "ProcessAutomationParticipant" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "process_automation_participants_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.build_process_automation]
}
# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      cli_server_url       = ${jsonencode(var.cli_server_url)}
      custom_idp           = ${jsonencode(var.custom_idp)}

      subaccount_id        = "${data.btp_subaccount.dc_mission.id}"

      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"

      cf_org_id            = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
      cf_org_name          = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]}"

      origin_key           = "${local.origin_key}"

      cf_space_name        = "${var.cf_space_name}"

      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_org_users         = ${jsonencode(var.cf_org_users)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}

      EOT
  filename = "../step2/terraform.tfvars"
}
