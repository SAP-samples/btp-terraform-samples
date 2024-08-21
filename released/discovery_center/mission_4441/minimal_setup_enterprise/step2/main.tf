# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "dev" {
  name = "dev"
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# SETUP ALL SERVICES FOR CF USAGE
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Remove current user from org roles
data "btp_whoami" "me" {}

locals {
  cf_org_admins = setsubtract(toset(var.cf_org_admins), [data.btp_whoami.me.email])
}

# Define Org User role
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset(local.cf_org_admins)
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = var.origin_key
}

# Define Org Manager role
resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset(local.cf_org_admins)
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_user]
}

# ------------------------------------------------------------------------------------------------------
# Assign CF space roles to the users
# ------------------------------------------------------------------------------------------------------
# Define Space Manager role
resource "cloudfoundry_space_role" "space_manager" {
  for_each = toset(var.cf_space_managers)

  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.dev.id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}
# Define Space Developer role
resource "cloudfoundry_space_role" "space_developer" {
  for_each = toset(var.cf_space_managers)

  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}
