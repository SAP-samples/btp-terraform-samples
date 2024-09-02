resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "dcmission4024${local.random_uuid}"

  # used (mandatory) services
  service_name__sap_build_apps                    = "sap-build-apps"
  service_name__sap_launchpad                     = "SAPLaunchpad"
  service_name__destination                       = "destination"
  # optional, if custom idp is used
  service_name__sap_identity_services_onboarding  = "sap-identity-services-onboarding"
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
# SERVICES/SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
# Setup sap-identity-services-onboarding (Cloud Identity Services)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_identity_services_onboarding" {
  count         = var.custom_idp == "" ? 1 : 0

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
# ------------------------------------------------------------------------------------------------------
# Setup sap-build-apps (SAP Build Apps)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_build_apps" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_build_apps
  plan_name     = var.service_plan__sap_build_apps
  amount        = 1
  depends_on    = [btp_subaccount_trust_configuration.fully_customized]
}
# Subscribe
resource "btp_subaccount_subscription" "sap-build-apps" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = "sap-appgyver-ee"
  plan_name     = var.service_plan__sap_build_apps
  depends_on    = [btp_subaccount_entitlement.sap_build_apps]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  #amount        = var.service_plan__sap_launchpad == "free" ? 1 : null
}

# Subscribe
resource "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_launchpad
  plan_name     = var.service_plan__sap_launchpad
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
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

# Get plan for destination service
data "btp_subaccount_service_plan" "by_name" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = var.service_plan__destination
  offering_name = local.service_name__destination
  depends_on    = [btp_subaccount_subscription.sap_launchpad]
}

# Create destination for Visual Cloud Functions
resource "btp_subaccount_service_instance" "vcf_destination" {
  subaccount_id  = data.btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.by_name.id
  name           = "SAP-Build-Apps-Runtime"
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          {
            Name                     = "SAP-Build-Apps-Runtime"
            Type                     = "HTTP"
            Description              = "Endpoint to SAP Build Apps runtime"
            URL                      = "https://${data.btp_subaccount.subaccount.subdomain}.cr1.${data.btp_subaccount.subaccount.region}.apps.build.cloud.sap/"
            ProxyType                = "Internet"
            Authentication           = "NoAuthentication"
            "HTML5.ForwardAuthToken" = true
          }
        ]
      }
    }
  })
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_subscription.sap-build-apps]
}
# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount.dc_mission]
}

# ------------------------------------------------------------------------------------------------------
# Create/Assign role collection "BuildAppsAdmin"
# ------------------------------------------------------------------------------------------------------
# Create
resource "btp_subaccount_role_collection" "build_apps_admin" {
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
# Assign users
resource "btp_subaccount_role_collection_assignment" "build_apps_admin" {
  for_each             = toset(var.build_apps_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "BuildAppsAdmin"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
  depends_on           = [btp_subaccount_role_collection.build_apps_admin]
}

# ------------------------------------------------------------------------------------------------------
# Create/Assign role collection "BuildAppsDeveloper"
# ------------------------------------------------------------------------------------------------------
# Create
resource "btp_subaccount_role_collection" "build_apps_developer" {
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
# Assign users
resource "btp_subaccount_role_collection_assignment" "build_apps_developer" {
  for_each             = toset(var.build_apps_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "BuildAppsDeveloper"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
  depends_on           = [btp_subaccount_role_collection.build_apps_developer]
}

# ------------------------------------------------------------------------------------------------------
# Create/Assign role collection "RegistryAdmin"
# ------------------------------------------------------------------------------------------------------
# Create
resource "btp_subaccount_role_collection" "build_apps_registry_admin" {
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
# Assign users
resource "btp_subaccount_role_collection_assignment" "build_apps_registry_admin" {
  for_each             = toset(var.build_apps_registry_admin)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "RegistryAdmin"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
  depends_on           = [btp_subaccount_role_collection.build_apps_registry_admin]
}

# ------------------------------------------------------------------------------------------------------
# Create/Assign role collection "RegistryDeveloper"
# ------------------------------------------------------------------------------------------------------
# Create
resource "btp_subaccount_role_collection" "build_apps_registry_developer" {
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
resource "btp_subaccount_role_collection_assignment" "build_apps_registry_developer" {
  for_each             = toset(var.build_apps_registry_developer)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "RegistryDeveloper"
  user_name            = each.value
  origin               = btp_subaccount_trust_configuration.fully_customized.origin
  depends_on           = [btp_subaccount_role_collection.build_apps_registry_developer]
}

# Assign users
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each             = toset("${var.launchpad_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      cli_server_url       = ${jsonencode(var.cli_server_url)}
      custom_idp           = "${var.custom_idp}"

      subaccount_id        = "${data.btp_subaccount.dc_mission.id}"

      EOT
  filename = "../step2/terraform.tfvars"
}