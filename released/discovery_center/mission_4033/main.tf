###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-4033-${local.random_uuid}", "_", "-"))
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.project[0].id
}


###############################################################################################
# Assignment of emergency admins to the sub account as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "subaccount_service_admin" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Assign custom IDP to sub account
######################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = data.btp_subaccount.project.id
  identity_provider = var.custom_idp != "" ? var.custom_idp : element(split("/", btp_subaccount_subscription.identity_instance[0].subscription_url), 2)
}

resource "btp_subaccount_entitlement" "identity" {
  count = var.custom_idp == "" ? 1 : 0

  subaccount_id = data.btp_subaccount.project.id
  service_name  = "sap-identity-services-onboarding"
  plan_name     = "default"
}

resource "btp_subaccount_subscription" "identity_instance" {
  count = var.custom_idp == "" ? 1 : 0

  subaccount_id = data.btp_subaccount.project.id
  app_name      = "sap-identity-services-onboarding"
  plan_name     = "default"
  parameters = jsonencode({
    cloud_service = "TEST"
  })
}


######################################################################
# Setup Kyma
######################################################################
data "btp_regions" "all" {}

# data "btp_subaccount" "this" {
#   id = data.btp_subaccount.project.id
# }

locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.project.region][0].iaas_provider
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "kymaruntime"
  plan_name     = lower(local.subaccount_iaas_provider)
  amount        = 1
}


resource "btp_subaccount_environment_instance" "kyma" {
  subaccount_id    = data.btp_subaccount.project.id
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

######################################################################
# Entitlement of all general services
######################################################################
resource "btp_subaccount_entitlement" "genentitlements" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = data.btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

######################################################################
# Assign Role Collection
######################################################################

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_entitlement.genentitlements]
  for_each             = toset(var.conn_dest_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}

######################################################################
# Create app subscription to SAP Integration Suite
######################################################################
resource "btp_subaccount_entitlement" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__sap_integration_suite
  plan_name     = var.service_plan__sap_integration_suite
}

data "btp_subaccount_subscriptions" "all" {
  subaccount_id = data.btp_subaccount.project.id
  depends_on    = [btp_subaccount_entitlement.sap_integration_suite]
}

resource "btp_subaccount_subscription" "sap_integration_suite" {
  subaccount_id = data.btp_subaccount.project.id
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
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
}

# ######################################################################
# # Create app subscription to SAP Build Process Automation 
# ######################################################################

resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}

# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_participants)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
}

###############################################################################################
# Prepare and setup app: SAP Build Apps
###############################################################################################
# Entitle subaccount for usage of SAP Build Apps
resource "btp_subaccount_entitlement" "sap_build_apps" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__sap_build_apps
  plan_name     = var.service_plan__sap_build_apps
  amount        = 1
  depends_on    = [btp_subaccount_trust_configuration.fully_customized]
}

# Create a subscription to the SAP Build Apps
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "sap-appgyver-ee"
  plan_name     = var.service_plan__sap_build_apps
  depends_on    = [btp_subaccount_entitlement.sap_build_apps]
}

# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.project.id
  depends_on    = [btp_subaccount_subscription.sap-build-apps_standard]
}

###############################################################################################
# Setup for role collection BuildAppsAdmin
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsAdmin" {
  subaccount_id = data.btp_subaccount.project.id
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
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "BuildAppsAdmin"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
}

###############################################################################################
# Setup for role collection BuildAppsDeveloper
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsDeveloper" {
  subaccount_id = data.btp_subaccount.project.id
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
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "BuildAppsDeveloper"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
}

###############################################################################################
# Setup for role collection RegistryAdmin
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryAdmin" {
  subaccount_id = data.btp_subaccount.project.id
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
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "RegistryAdmin"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
}

###############################################################################################
# Setup for role collection RegistryDeveloper
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryDeveloper" {
  subaccount_id = data.btp_subaccount.project.id
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
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "RegistryDeveloper"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
}
