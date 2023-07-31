# Create a subscription to the SAP Build Apps
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = var.subaccount_id
  app_name      = "sap-appgyver-ee"
  plan_name     = "standard"
}

# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = var.subaccount_id
  depends_on =[btp_subaccount_subscription.sap-build-apps_standard]
}

###############################################################################################
# Setup for role collection BuildAppsAdmin
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsAdmin" {
    subaccount_id = var.subaccount_id
    name = "BuildAppsAdmin"

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
  depends_on = [btp_subaccount_role_collection.build_apps_BuildAppsAdmin]
  for_each = toset(var.users_BuildAppsAdmin)
      subaccount_id = var.subaccount_id
      role_collection_name = "BuildAppsAdmin"
      user_name            = each.value
      origin               = var.custom_idp
}

###############################################################################################
# Setup for role collection BuildAppsDeveloper
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_BuildAppsDeveloper" {
    subaccount_id = var.subaccount_id
    name = "BuildAppsDeveloper"

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
  depends_on = [btp_subaccount_role_collection.build_apps_BuildAppsDeveloper]
  for_each = toset(var.users_BuildAppsDeveloper)
      subaccount_id = var.subaccount_id
      role_collection_name = "BuildAppsDeveloper"
      user_name            = each.value
      origin               = var.custom_idp
}

###############################################################################################
# Setup for role collection RegistryAdmin
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryAdmin" {
    subaccount_id = var.subaccount_id
    name = "RegistryAdmin"

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
  depends_on = [btp_subaccount_role_collection.build_apps_RegistryAdmin]
  for_each = toset(var.users_RegistryAdmin)
      subaccount_id = var.subaccount_id
      role_collection_name = "RegistryAdmin"
      user_name            = each.value
      origin               = var.custom_idp
}

###############################################################################################
# Setup for role collection RegistryDeveloper
###############################################################################################
# Create the role collection
resource "btp_subaccount_role_collection" "build_apps_RegistryDeveloper" {
    subaccount_id = var.subaccount_id
    name = "RegistryDeveloper"

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
  depends_on = [btp_subaccount_role_collection.build_apps_RegistryDeveloper]
  for_each = toset(var.users_RegistryDeveloper)
      subaccount_id = var.subaccount_id
      role_collection_name = "RegistryDeveloper"
      user_name            = each.value
      origin               = var.custom_idp_origin
}
