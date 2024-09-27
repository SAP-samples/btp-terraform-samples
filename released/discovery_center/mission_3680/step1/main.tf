# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-4356-${local.random_uuid}", "_", "-"))
  # If a cf_org_name was defined by the user, take that as a subaccount_cf_org. Otherwise create it.
  subaccount_cf_org = length(var.cf_org_name) > 0 ? var.cf_org_name : substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
}

locals {
  service_name__sap_build_apps = "sap-build-apps"
  service_name__build_workzone = "SAPLaunchpad"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}


# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account
# ------------------------------------------------------------------------------------------------------
locals {
  service_name__sap_identity_services_onboarding = "sap-identity-services-onboarding"
}

# Entitle
resource "btp_subaccount_entitlement" "sap_identity_services_onboarding" {
  count = var.custom_idp == "" ? 1 : 0

  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_identity_services_onboarding
  plan_name     = var.service_plan__sap_identity_services_onboarding
}
# Subscribe
resource "btp_subaccount_subscription" "sap_identity_services_onboarding" {
  count = var.custom_idp == "" ? 1 : 0

  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_identity_services_onboarding
  plan_name     = var.service_plan__sap_identity_services_onboarding
  depends_on    = [btp_subaccount_entitlement.sap_identity_services_onboarding]
}

# IdP trust configuration
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = data.btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp != "" ? var.custom_idp : element(split("/", btp_subaccount_subscription.sap_identity_services_onboarding[0].subscription_url), 2)
}

locals {
  custom_idp_tenant    = element(split(".", btp_subaccount_trust_configuration.fully_customized.identity_provider), 0)
  origin_key           = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : "sap.default"
  origin_key_app_users = var.custom_idp_apps_origin_key
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  origin               = local.origin_key
}
# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
  origin               = local.origin_key
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud tools
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "hana-cloud-tools"
  plan_name     = "tools"
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = "hana-cloud-tools"
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin" {
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = var.hana_system_admin
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}

# Get plan for SAP HANA Cloud
data "btp_subaccount_service_plan" "hana_cloud" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  offering_name = "hana-cloud"
  name          = "hana"
  depends_on    = [btp_subaccount_entitlement.hana_cloud]
}

resource "btp_subaccount_service_instance" "hana_cloud" {
  subaccount_id  = data.btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
  name           = "my-hana-cloud-instance"
  depends_on     = [btp_subaccount_entitlement.hana_cloud]
  parameters = jsonencode(
    {
      "data" : {
        "memory" : 32,
        "edition" : "cloud",
        "systempassword" : "${var.hana_system_password}",
        "additionalWorkers" : 0,
        "disasterRecoveryMode" : "no_disaster_recovery",
        "enabledservices" : {
          "docstore" : false,
          "dpserver" : true,
          "scriptserver" : false
        },
        "requestedOperation" : {},
        "serviceStopped" : false,
        "slaLevel" : "standard",
        "storage" : 120,
        "vcpu" : 2,
        "whitelistIPs" : ["0.0.0.0/0"]
      }
  })

  timeouts = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

# Create service binding to SAP HANA Cloud service 
resource "btp_subaccount_service_binding" "hana_cloud" {
  subaccount_id       = data.btp_subaccount.dc_mission.id
  service_instance_id = btp_subaccount_service_instance.hana_cloud.id
  name                = "hana-cloud-key"
}



# ------------------------------------------------------------------------------------------------------
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = data.btp_subaccount.dc_mission.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.cf_landscape_label.output
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}

# ------------------------------------------------------------------------------------------------------
# Event Mesh
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "event_mesh" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "enterprise-messaging"
  plan_name     = "default"
}

resource "btp_subaccount_entitlement" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "enterprise-messaging-hub"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = "enterprise-messaging-hub"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.event_mesh_application]
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_admin" {
  depends_on           = [btp_subaccount_subscription.event_mesh_application]
  for_each             = toset(var.event_mesh_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Enterprise Messaging Administrator"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_developer" {
  depends_on           = [btp_subaccount_subscription.event_mesh_application]
  for_each             = toset(var.event_mesh_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Enterprise Messaging Developer"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: SAP Build Apps
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP Build Apps
resource "btp_subaccount_entitlement" "sap_build_apps" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_build_apps
  plan_name     = var.service_plan__sap_build_apps
  amount        = 1
  depends_on    = [btp_subaccount_trust_configuration.fully_customized]
}

# Create a subscription to the SAP Build Apps
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = "sap-appgyver-ee"
  plan_name     = var.service_plan__sap_build_apps
  depends_on    = [btp_subaccount_entitlement.sap_build_apps]
}

# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_subscription.sap-build-apps_standard]
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection BuildAppsAdmin
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsAdmin" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "BuildAppsAdmin"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["BuildAppsAdmin"], role.name)
  ]
}
# Assign users to the role collection
resource "btp_subaccount_role_collection_assignment" "build_apps_BuildAppsAdmin" {
  depends_on           = [btp_subaccount_role_collection.build_apps_BuildAppsAdmin]
  for_each             = toset(var.users_buildApps_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "BuildAppsAdmin"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection BuildAppsDeveloper
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsDeveloper" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "BuildAppsDeveloper"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["BuildAppsDeveloper"], role.name)
  ]
}
# Assign users to the role collection
resource "btp_subaccount_role_collection_assignment" "build_apps_BuildAppsDeveloper" {
  depends_on           = [btp_subaccount_role_collection.build_apps_BuildAppsDeveloper]
  for_each             = toset(var.users_buildApps_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "BuildAppsDeveloper"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection RegistryAdmin
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryAdmin" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "RegistryAdmin"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["RegistryAdmin"], role.name)
  ]
}
# Assign users to the role collection
resource "btp_subaccount_role_collection_assignment" "build_apps_RegistryAdmin" {
  depends_on           = [btp_subaccount_role_collection.build_apps_RegistryAdmin]
  for_each             = toset(var.users_registry_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "RegistryAdmin"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection RegistryDeveloper
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryDeveloper" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "RegistryDeveloper"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["RegistryDeveloper"], role.name)
  ]
}
# Assign users to the role collection
resource "btp_subaccount_role_collection_assignment" "build_apps_RegistryDeveloper" {
  depends_on           = [btp_subaccount_role_collection.build_apps_RegistryDeveloper]
  for_each             = toset(var.users_registry_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "RegistryDeveloper"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      subaccount_id        = "${data.btp_subaccount.dc_mission.id}"
      globalaccount        = "${var.globalaccount}"
      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id            = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
      cf_space_name        = "${var.cf_space_name}"
      cf_org_users         = ${jsonencode(var.cf_org_users)}
      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}
      custom_idp           = "${btp_subaccount_trust_configuration.fully_customized.identity_provider}"
      EOT
  filename = "../step2/terraform.tfvars"
}