# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-4033-${local.random_uuid}", "_", "-"))
}

locals {
  service_name__sap_build_apps                 = "sap-build-apps"
  service_name__sap_process_automation         = "process-automation"
  service_name__sap_process_automation_service = "process-automation-service"
  service_name__sap_integration_suite          = "integrationsuite"
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
# Assignment of emergency admins to the sub account as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  origin               = local.origin_key
}

resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
  origin               = local.origin_key
}


# ------------------------------------------------------------------------------------------------------
# Setup Kyma
# ------------------------------------------------------------------------------------------------------
data "btp_regions" "all" {}

locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.dc_mission.region][0].iaas_provider
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "kymaruntime"
  plan_name     = lower(local.subaccount_iaas_provider)
  amount        = 1
}


resource "btp_subaccount_environment_instance" "kyma" {
  subaccount_id    = data.btp_subaccount.dc_mission.id
  name             = var.kyma_instance.name
  environment_type = "kyma"
  service_name     = "kymaruntime"
  plan_name        = lower(local.subaccount_iaas_provider)
  parameters = jsonencode({
    name            = var.kyma_instance.name
    region          = var.kyma_instance.region
    machine_type    = var.kyma_instance.machine_type
    auto_scaler_min = var.kyma_instance.auto_scaler_min
    auto_scaler_max = var.kyma_instance.auto_scaler_max
  })
  timeouts = {
    create = var.kyma_instance.createtimeout
    update = var.kyma_instance.updatetimeout
    delete = var.kyma_instance.deletetimeout
  }
  depends_on = [btp_subaccount_entitlement.kymaruntime]
}

# ------------------------------------------------------------------------------------------------------
# Create app subscription to SAP Integration Suite
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_integration_suite
  plan_name     = var.service_plan__sap_integration_suite
}

data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_entitlement.sap_integration_suite]
}

resource "btp_subaccount_subscription" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name = [
    for subscription in data.btp_subaccount_subscriptions.all.values :
    subscription
    if subscription.commercial_app_name == local.service_name__sap_integration_suite
  ][0].app_name
  plan_name  = var.service_plan__sap_integration_suite
  depends_on = [data.btp_subaccount_subscriptions.all]
}

resource "btp_subaccount_role_collection_assignment" "int_prov" {
  depends_on           = [btp_subaccount_subscription.sap_integration_suite]
  for_each             = toset(var.int_provisioners)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

resource "btp_subaccount_entitlement" "api_portal" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "apimanagement-apiportal"
  plan_name     = var.service_plan__apimanagement_apiportal
}

resource "btp_subaccount_entitlement" "dev_portal" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "apimanagement-devportal"
  plan_name     = var.service_plan__apimanagement_devportal
}

# # ------------------------------------------------------------------------------------------------------
# # Create app subscription to SAP Build Process Automation 
# # ------------------------------------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}

# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_participants)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
  origin               = local.origin_key_app_users
}

# # ------------------------------------------------------------------------------------------------------
# # Create service instance to SAP Build Process Automation 
# # ------------------------------------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "process_automation_service" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_process_automation_service
  plan_name     = var.service_plan__sap_process_automation_service
  depends_on    = [btp_subaccount_subscription.build_process_automation]
}

# Get plan for SAP AI Core service
data "btp_subaccount_service_plan" "process_automation_service" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  offering_name = local.service_name__sap_process_automation_service
  name          = var.service_plan__sap_process_automation_service
  depends_on    = [btp_subaccount_entitlement.process_automation_service]
}

# Create service instance for SAP Build Process Automation Service
resource "btp_subaccount_service_instance" "process_automation_service_instance" {
  subaccount_id  = data.btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.process_automation_service.id
  name           = "build-process-automation-service-instance"
  depends_on     = [btp_subaccount_entitlement.process_automation_service]
}

# Create service binding to SAP Build Process Automation Service (exposed for a specific user group)
resource "btp_subaccount_service_binding" "process_automation_service_instance_binding" {
  subaccount_id       = data.btp_subaccount.dc_mission.id
  service_instance_id = btp_subaccount_service_instance.process_automation_service_instance.id
  name                = "build-process-automation-service-instance-key"
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
      globalaccount        = "${var.globalaccount}"
      subaccount_id        = "${data.btp_subaccount.dc_mission.id}"
      EOT
  filename = "../step2/terraform.tfvars"
}
