# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = "space"
  org  = var.cf_org_id
}


# # ------------------------------------------------------------------------------------------------------
# # SETUP ALL SERVICES FOR CF USAGE
# # ------------------------------------------------------------------------------------------------------
# # ------------------------------------------------------------------------------------------------------
# # Setup sdm
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "sdm" {
#   subaccount_id = var.subaccount_id
#   service_name  = "sdm"
#   plan_name     = "build-code"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup mobile-services
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "mobile_services" {
#   subaccount_id = var.subaccount_id
#   service_name  = "mobile-services"
#   plan_name     = "build-code"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup cloud-logging
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "cloud_logging" {
#   subaccount_id = var.subaccount_id
#   service_name  = "cloud-logging"
#   plan_name     = "build-code"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup alert-notification
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "alert_notification" {
#   subaccount_id = var.subaccount_id
#   service_name  = "alert-notification"
#   plan_name     = "build-code"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup transport
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "transport" {
#   subaccount_id = var.subaccount_id
#   service_name  = "transport"
#   plan_name     = "standard"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup autoscaler
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "autoscaler" {
#   subaccount_id = var.subaccount_id
#   service_name  = "autoscaler"
#   plan_name     = "standard"
# }

# # ------------------------------------------------------------------------------------------------------
# # Setup feature-flags
# # ------------------------------------------------------------------------------------------------------
# # Entitle 
# resource "btp_subaccount_entitlement" "feature_flags" {
#   subaccount_id = var.subaccount_id
#   service_name  = "feature-flags"
#   plan_name     = "standard"
# }

# ------------------------------------------------------------------------------------------------------
#  ROLES AND ROLE COLLECTIONS
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Prepare the list of admins and roles for the CF Org 
# ------------------------------------------------------------------------------------------------------
locals {
  role_mapping_admins_org = distinct(flatten([
    for admin in var.admins : [
      for role in var.roles_cf_org : {
        user_name = admin
        role_name = role
      }
    ]
    ]
  ))
}
locals {
  role_mapping_admins_space = distinct(flatten([
    for admin in var.admins : [
      for role in var.roles_cf_space : {
        user_name = admin
        role_name = role
      }
    ]
    ]
  ))
}

# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Org Manager role
resource "cloudfoundry_org_role" "all_org_roles" {

  for_each = { for entry in local.role_mapping_admins_org : "${entry.user_name}.${entry.role_name}" => entry }

  username = each.value.user_name
  type     = each.value.role_name
  org      = var.cf_org_id
  origin   = var.identity_provider

}

# ------------------------------------------------------------------------------------------------------
# Assign CF space roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Space Manager role
resource "cloudfoundry_space_role" "my_role" {
  for_each = { for entry in local.role_mapping_admins_space : "${entry.user_name}.${entry.role_name}" => entry }

  username   = each.value.user_name
  type       = each.value.role_name
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.all_org_roles]
}


# ------------------------------------------------------------------------------------------------------
# Output the CF API endpoint