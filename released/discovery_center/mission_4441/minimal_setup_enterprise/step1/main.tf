# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 4441
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "dcmission4441${local.random_uuid}"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

data "btp_subaccount" "subaccount" {
  id = data.btp_subaccount.dc_mission.id
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
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
}
# Take the landscape label from the first CF environment if no environment label is provided (this replaces the previous null_resource)
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# Entitle
resource "btp_subaccount_entitlement" "cloudfoundry" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__cloudfoundry
  plan_name     = var.service_plan__cloudfoundry
  amount        = 1
}

# Create instance
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  depends_on       = [btp_subaccount_subscription.build_code]
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
  service_name__build_code    = "build-code"
  service_name__sapappstudio  = "sapappstudio"
  service_name__sap_launchpad = "SAPLaunchpad"
}
# ------------------------------------------------------------------------------------------------------
# Setup build-code (SAP Build Code)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__build_code
  plan_name     = var.service_plan__build_code
}
# Subscribe
resource "btp_subaccount_subscription" "build_code" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__build_code
  plan_name     = var.service_plan__build_code
  depends_on    = [btp_subaccount_entitlement.build_code]
}

# ------------------------------------------------------------------------------------------------------
# Setup sapappstudio (SAP Business Application Studio)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sapappstudio" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sapappstudio
  plan_name     = var.service_plan__sapappstudio
}
# Subscribe
resource "btp_subaccount_subscription" "sapappstudio" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sapappstudio
  plan_name     = var.service_plan__sapappstudio
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.sapappstudio]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
}
# Subscribe
resource "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
locals {
  subaccount_admins     = var.subaccount_admins
  build_code_admins     = var.build_code_admins
  build_code_developers = var.build_code_developers

  custom_idp_tenant = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : ""
}

data "btp_whoami" "me" {}

# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_subscription.sapappstudio]
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
# Assign role collection for Build Code Administrator
# ------------------------------------------------------------------------------------------------------
# Assign roles to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection" "build_code_administrator" {
  subaccount_id = data.btp_subaccount.dc_mission.id
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
  for_each             = toset("${local.build_code_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Administrator"
  user_name            = each.value
  origin               = var.custom_idp_apps_origin_key
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}
# Assign logged in user to the role collection "Build Code Administrator" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "build_code_administrator_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Administrator"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Build Code Developer"
# ------------------------------------------------------------------------------------------------------
# Create role collection "Build Code Developer"  
resource "btp_subaccount_role_collection" "build_code_developer" {
  subaccount_id = data.btp_subaccount.dc_mission.id
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
  for_each             = toset("${local.build_code_developers}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Developer"
  user_name            = each.value
  origin               = var.custom_idp_apps_origin_key
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
}

# Assign logged in user to the role collection "Build Code Developer" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "build_code_developer_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Developer"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
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
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}


      EOT
  filename = "../step2/terraform.tfvars"
}
