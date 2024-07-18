###
# Assignment of Cloud Foundry space roles 
###
resource "cloudfoundry_org_role" "org_managers" {
  for_each = toset("${var.cf_org_managers}")
  username = each.value
  type     = "org_manager"
  org      = var.cf_org_id
}

###
# Creation of Cloud Foundry space
###
data "cloudfoundry_space" "abap_space" {
  name = "dev"
  org  = var.cf_org_id
}

resource "cloudfoundry_space" "abap_space" {
  count = data.cloudfoundry_space.abap_space == null ? 1 : 0

  name = "dev"
  org  = var.cf_org_id
}

###
# Assignment of Cloud Foundry space roles 
###
resource "cloudfoundry_space_role" "space_managers" {
  for_each = toset("${var.cf_space_managers}")
  username = each.value
  type     = "space_manager"
  space    = data.cloudfoundry_space.abap_space.id
}

resource "cloudfoundry_space_role" "space_developers" {
  for_each = toset("${var.cf_space_developers}")
  username = each.value
  type     = "space_developer"
  space    = data.cloudfoundry_space.abap_space.id
}

###
# Creation of service instance for ABAP
###
data "cloudfoundry_service" "abap_service_plans" {
  name = "abap-trial"
}

resource "cloudfoundry_service_instance" "abap_trial" {
  depends_on   = [cloudfoundry_space_role.space_managers, cloudfoundry_space_role.space_developers]
  name         = "abap-trial"
  space        = data.cloudfoundry_space.abap_space.id
  service_plan = data.cloudfoundry_service.abap_service_plans.service_plans["shared"]
  type         = "managed"
  parameters = jsonencode({
    email = "${var.abap_admin_email}"
  })
  timeouts = {
    create = "30m"
    delete = "30m"
    update = "30m"
  }
}

###
# Creation of service key for ABAP Development Tools (ADT)
###
resource "cloudfoundry_service_credential_binding" "abap_trial_service_key" {
  type             = "key"
  name             = "abap_trial_adt_key"
  service_instance = cloudfoundry_service_instance.abap_trial.id
}
