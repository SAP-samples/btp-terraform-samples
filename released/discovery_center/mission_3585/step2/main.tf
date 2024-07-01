# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Org User role
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset("${var.cf_org_admins}")
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = var.cf_origin
}
# Define Org Manager role
resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset("${var.cf_org_admins}")
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = var.cf_origin
  depends_on = [cloudfoundry_org_role.organization_user]
}
