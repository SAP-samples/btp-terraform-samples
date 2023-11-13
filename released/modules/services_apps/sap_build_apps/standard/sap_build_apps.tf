# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "0.6.0-beta2"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Create a subscription to the SAP Build Apps
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = var.subaccount_id
  app_name      = "sap-appgyver-ee"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Get all roles in the subaccount
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount_roles" "all" {
  subaccount_id = var.subaccount_id
  depends_on    = [btp_subaccount_subscription.sap-build-apps_standard]
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection BuildAppsAdmin
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsAdmin" {
  subaccount_id = var.subaccount_id
  name          = "BuildAppsAdmin"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["BuildAppsAdmin"], role.name)
  ]
}

# ------------------------------------------------------------------------------------------------------
# Assign users to the role collection
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "build_apps_BuildAppsAdmin" {
  depends_on           = [btp_subaccount_role_collection.build_apps_BuildAppsAdmin]
  for_each             = toset(var.users_BuildAppsAdmin)
  subaccount_id        = var.subaccount_id
  role_collection_name = "BuildAppsAdmin"
  user_name            = each.value
  origin               = var.custom_idp_origin
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection BuildAppsDeveloper
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsDeveloper" {
  subaccount_id = var.subaccount_id
  name          = "BuildAppsDeveloper"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["BuildAppsDeveloper"], role.name)
  ]
}

# ------------------------------------------------------------------------------------------------------
# Assign users to the role collection
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "build_apps_BuildAppsDeveloper" {
  depends_on           = [btp_subaccount_role_collection.build_apps_BuildAppsDeveloper]
  for_each             = toset(var.users_BuildAppsDeveloper)
  subaccount_id        = var.subaccount_id
  role_collection_name = "BuildAppsDeveloper"
  user_name            = each.value
  origin               = var.custom_idp_origin
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection RegistryAdmin
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryAdmin" {
  subaccount_id = var.subaccount_id
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
  for_each             = toset(var.users_RegistryAdmin)
  subaccount_id        = var.subaccount_id
  role_collection_name = "RegistryAdmin"
  user_name            = each.value
  origin               = var.custom_idp_origin
}

# ------------------------------------------------------------------------------------------------------
# Setup for role collection RegistryDeveloper
# ------------------------------------------------------------------------------------------------------
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryDeveloper" {
  subaccount_id = var.subaccount_id
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
  for_each             = toset(var.users_RegistryDeveloper)
  subaccount_id        = var.subaccount_id
  role_collection_name = "RegistryDeveloper"
  user_name            = each.value
  origin               = var.custom_idp_origin
}
# ------------------------------------------------------------------------------------------------------
# Create destination for Visual Cloud Functions
# ------------------------------------------------------------------------------------------------------
# Get plan for destination service
data "btp_subaccount_service_plan" "by_name" {
  subaccount_id = var.subaccount_id
  name          = "lite"
  offering_name = "destination"
}

# ------------------------------------------------------------------------------------------------------
# Get subaccount data
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount" "subaccount" {
  id = var.subaccount_id
}

# ------------------------------------------------------------------------------------------------------
# Create the destination
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_service_instance" "vcf_destination" {
  subaccount_id  = var.subaccount_id
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
