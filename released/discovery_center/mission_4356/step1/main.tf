# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 4356
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "dcmission4356${local.random_uuid}"
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
  service_name__cloudfoundry    = "cloudfoundry"
  service_name__connectivity    = "connectivity"
  service_name__destination     = "destination"
  service_name__html5_apps_repo = "html5-apps-repo"
  service_name__xsuaa           = "xsuaa"
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
# Setup connectivity (Connectivity Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "connectivity" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__connectivity
  plan_name     = var.service_plan__connectivity
}

# ------------------------------------------------------------------------------------------------------
# Setup destination (Destination Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__destination
  plan_name     = var.service_plan__destination
}

# ------------------------------------------------------------------------------------------------------
# Setup destination (HTML5 Application Repository Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "html5_apps_repo" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__html5_apps_repo
  plan_name     = var.service_plan__html5_apps_repo
}

# ------------------------------------------------------------------------------------------------------
# Setup destination (Authorization and Trust Management Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "xsuaa" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__xsuaa
  plan_name     = var.service_plan__xsuaa
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__integrationsuite = "integrationsuite"
  service_name__sapappstudio     = "sapappstudio"
}
# ------------------------------------------------------------------------------------------------------
# Setup integrationsuite (Integration Suite Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "integrationsuite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__integrationsuite
  plan_name     = var.service_plan__integrationsuite
  amount        = var.service_plan__integrationsuite == "free" ? 1 : null
}

data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_entitlement.integrationsuite]
}

# Subscribe
resource "btp_subaccount_subscription" "integrationsuite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name = [
    for subscription in data.btp_subaccount_subscriptions.all.values :
    subscription
    if subscription.commercial_app_name == local.service_name__integrationsuite
  ][0].app_name
  plan_name  = var.service_plan__integrationsuite
  depends_on = [data.btp_subaccount_subscriptions.all]
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
  depends_on    = [btp_subaccount_entitlement.sapappstudio]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
locals {
  subaccount_admins         = var.subaccount_admins
  subaccount_service_admins = var.subaccount_service_admins

  integration_provisioners = var.integration_provisioners
  sapappstudio_admins      = var.sapappstudio_admins
  sapappstudio_developers  = var.sapappstudio_developers

  cloud_connector_admins          = var.cloud_connector_admins
  connectivity_destination_admins = var.connectivity_destination_admins

  custom_idp_tenant = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : ""
}

data "btp_whoami" "me" {}
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
# Assign role collection "Integration_Provisioner"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "integration_provisioner" {
  for_each             = toset("${local.integration_provisioners}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
  origin               = local.origin_key
  depends_on           = [btp_subaccount_subscription.integrationsuite]
}

# Assign logged in user to the role collection "Integration_Provisioner" if not custom idp user
resource "btp_subaccount_role_collection_assignment" "integration_provisioner_default" {
  count                = data.btp_whoami.me.issuer != var.custom_idp ? 1 : 0
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Integration_Provisioner"
  user_name            = data.btp_whoami.me.email
  origin               = "sap.default"
  depends_on           = [btp_subaccount_subscription.integrationsuite]
}


# ------------------------------------------------------------------------------------------------------
# Assign role collection "Business_Application_Studio_Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "bas_admins" {
  for_each             = toset(local.sapappstudio_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.sapappstudio]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Business_Application_Studio_Developer"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "bas_developer" {
  for_each             = toset(local.sapappstudio_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.sapappstudio]
}


resource "btp_subaccount_role_collection_assignment" "cloud_connector_admins" {
  for_each             = toset(local.cloud_connector_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_entitlement.connectivity]
}

resource "btp_subaccount_role_collection_assignment" "connectivity_destination_admins" {
  for_each             = toset(local.connectivity_destination_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_entitlement.destination]
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
