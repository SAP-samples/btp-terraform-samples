data "btp_whoami" "me" {}
# ------------------------------------------------------------------------------------------------------
# Import custom trust config and disable for user login
# ------------------------------------------------------------------------------------------------------
locals {
  available_for_user_logon = data.btp_whoami.me.issuer != var.custom_idp ? true : false
}

import {
  to = btp_subaccount_trust_configuration.default
  id = "${var.subaccount_id},sap.default"
}

resource "btp_subaccount_trust_configuration" "default" {
  subaccount_id            = var.subaccount_id
  identity_provider        = ""
  auto_create_shadow_users = false
  available_for_user_logon = local.available_for_user_logon
}

# ------------------------------------------------------------------------------------------------------
# ENVIRONMENTS (plans, user lists and other vars)
# ------------------------------------------------------------------------------------------------------
# cloudfoundry (Cloud Foundry Environment)
# ------------------------------------------------------------------------------------------------------
#
# Create space
resource "cloudfoundry_space" "dev" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

locals {
  # origin_key is default (sap.ids) if issuer (idp) of logged in user is not custom_idp, otherwise calculated from custom_idp (<<tenant-id>>-platform)
  custom_idp_tenant_id = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key        = data.btp_whoami.me.issuer != var.custom_idp ? "sap.ids" : "${local.custom_idp_tenant_id}-platform"

  # Remove logged in user (which was already added before when cf env was created) 
  cf_org_managers = setsubtract(toset(var.cf_org_managers), [data.btp_whoami.me.email])
  cf_org_users  = setsubtract(toset(var.cf_org_users), [data.btp_whoami.me.email])
}

# cf_org_users: Assign organization_user role
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset(local.cf_org_users)
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = local.origin_key
}

# cf_org_managers: Assign organization_manager role
resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset(local.cf_org_managers)
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_user]
}

# cf_space_managers: Assign space_manager role
resource "cloudfoundry_space_role" "space_manager" {
  for_each   = toset(var.cf_space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.dev.id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}

# cf_space_developers: Assign space_developer role
resource "cloudfoundry_space_role" "space_developer" {
  for_each   = toset(var.cf_space_developers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = local.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}

