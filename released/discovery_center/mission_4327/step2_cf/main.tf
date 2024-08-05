######################################################################
# Create space using CF provider
######################################################################
resource "cloudfoundry_space" "dev" {
  name = "DEV"
  org  = var.cf_org_id
}

######################################################################
# add org and space users and managers
######################################################################
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset(var.cf_org_users)
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = var.cf_origin
}

resource "cloudfoundry_org_role" "organization_manager" {
  for_each = toset(var.cf_org_admins)
  username = each.value
  type     = "organization_manager"
  org      = var.cf_org_id
  origin   = var.cf_origin
}

resource "cloudfoundry_space_role" "space_developer" {
  for_each   = toset(var.cf_space_developers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = var.cf_origin
  depends_on = [cloudfoundry_org_role.organization_user, cloudfoundry_org_role.organization_manager]
}

resource "cloudfoundry_space_role" "space_manager" {
  for_each   = toset(var.cf_space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.dev.id
  origin     = var.cf_origin
  depends_on = [cloudfoundry_org_role.organization_user, cloudfoundry_org_role.organization_manager]
}
