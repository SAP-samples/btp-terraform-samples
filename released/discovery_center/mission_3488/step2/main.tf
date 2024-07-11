
# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Org User role
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset("${var.cf_org_admins}")
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = var.origin
}

resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset("${var.cf_org_admins}")
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

resource "cloudfoundry_org_role" "billing_managers" {
  for_each   = toset("${var.cf_org_billing_managers}")
  username   = each.value
  type       = "organization_billing_manager"
  org        = var.cf_org_id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

resource "cloudfoundry_org_role" "org_auditors" {
  for_each   = toset("${var.cf_org_auditors}")
  username   = each.value
  type       = "organization_auditor"
  org        = var.cf_org_id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "sac_space" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Assignment of Cloud Foundry org roles 
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space_role" "space_managers" {
  for_each   = toset("${var.cf_space_managers}")
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.sac_space.id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

resource "cloudfoundry_space_role" "space_developers" {
  for_each   = toset("${var.cf_space_developers}")
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.sac_space.id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

resource "cloudfoundry_space_role" "space_auditors" {
  for_each   = toset("${var.cf_space_auditors}")
  username   = each.value
  type       = "space_auditor"
  space      = cloudfoundry_space.sac_space.id
  origin     = var.origin
  depends_on = [cloudfoundry_org_role.organization_user]
}

# ------------------------------------------------------------------------------------------------------
# Creation of service instance for SAP Analytics Bloud
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_service" "sac_service_plans" {
  name = local.service_name__sac
}

resource "cloudfoundry_service_instance" "sac_si" {
  depends_on   = [cloudfoundry_space_role.space_managers, cloudfoundry_space_role.space_developers]
  name         = "service-analytics-planning-osb"
  space        = cloudfoundry_space.sac_space.id
  service_plan = data.cloudfoundry_service.sac_service_plans.service_plans[var.service_plan__sac]
  type         = "managed"
  parameters = jsonencode({
    "first_name" : "${var.sac_param_first_name}",
    "last_name" : "${var.sac_param_last_name}",
    "email" : "${var.sac_param_email}",
    "confirm_email" : "${var.sac_param_email}",
    "host_name" : "${var.sac_param_host_name}",
    "number_of_business_intelligence_licenses" : var.sac_param_number_of_business_intelligence_licenses,
    "number_of_planning_professional_licenses" : var.sac_param_number_of_professional_licenses,
    "number_of_planning_standard_licenses" : var.sac_param_number_of_business_standard_licenses
  })
  timeouts = {
    create = "2h"
    delete = "2h"
    update = "2h"
  }
}
