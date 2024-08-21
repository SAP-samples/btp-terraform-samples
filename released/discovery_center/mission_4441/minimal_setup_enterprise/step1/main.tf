# ------------------------------------------------------------------------------------------------------
# SUBACCOUNT SETUP
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = join("-", ["dc-mission-4441", random_uuid.uuid.result])
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account (if custom_idp is set)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  # Only create trust configuration if custom_idp has been set 
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp
}
# ------------------------------------------------------------------------------------------------------
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "cloudfoundry" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "cloudfoundry"
  plan_name     = "build-code"
  amount        = 1
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  depends_on       = [btp_subaccount_entitlement.build_code]
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = "cf-${random_uuid.uuid.result}"
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "build-code"
  landscape_label  = terraform_data.cf_landscape_label.output

  parameters = jsonencode({
    instance_name = "cf-${random_uuid.uuid.result}"
  })
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Setup build-code
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "build-code"
  plan_name     = "standard"
  amount        = 1
}
# Subscribe
resource "btp_subaccount_subscription" "build_code" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "build-code"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.build_code]
}

# ------------------------------------------------------------------------------------------------------
# Setup sapappstudio
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sapappstudio" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "sapappstudio"
  plan_name     = "build-code"
}
# Subscribe (depends on subscription of build-code)
resource "btp_subaccount_subscription" "sapappstudio" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "sapappstudio"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.sapappstudio]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_launchpad" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "SAPLaunchpad"
  plan_name     = "foundation"
}
# Subscribe
resource "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "SAPLaunchpad"
  plan_name     = "foundation"
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# Get all available subaccount roles
data "btp_subaccount_roles" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_subscription.sapappstudio]
}
# ------------------------------------------------------------------------------------------------------
# Assign role collection for Build Code Administrator
# ------------------------------------------------------------------------------------------------------
# Assign roles to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection" "build_code_administrator" {
  subaccount_id = btp_subaccount.dc_mission.id
  name          = "Build Code Administrator"
  description   = "The role collection for an administrator on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Administrator", "Administrator", "RegistryAdmin"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection_assignment" "build_code_administrator" {
  for_each             = toset("${var.build_code_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Build Code Developer"
# ------------------------------------------------------------------------------------------------------
# Create role collection "Build Code Developer"  
resource "btp_subaccount_role_collection" "build_code_developer" {
  subaccount_id = btp_subaccount.dc_mission.id
  name          = "Build Code Developer"
  description   = "The role collection for a developer on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Developer", "Developer", "Workzone_User"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Developer"
resource "btp_subaccount_role_collection_assignment" "build_code_developer" {
  for_each             = toset("${var.build_code_developers}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount.dc_mission]
}

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      cli_server_url       = ${jsonencode(var.cli_server_url)}

      subaccount_id        = "${btp_subaccount.dc_mission.id}"

      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"

      cf_org_id            = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
      cf_org_name          = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]}"

      origin_key           = "${var.origin}"

      cf_space_name        = "${var.cf_space_name}"

      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}


      EOT
  filename = "../step2/terraform.tfvars"
}
