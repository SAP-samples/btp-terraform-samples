###
# Setup of names based on variables
###
locals {
  abap_service_instance_name = "abap-${var.abap_sid}"
}

###
# Assignment of Cloud Foundry org roles 
###
resource "cloudfoundry_org_role" "org_managers" {
  for_each = toset("${var.cf_org_managers}")
  username = each.value
  type     = "organization_manager"
  org      = var.cf_org_id
  origin   = var.origin
}


resource "cloudfoundry_org_role" "billing_managers" {
  for_each = toset("${var.cf_org_billing_managers}")
  username = each.value
  type     = "organization_billing_manager"
  org      = var.cf_org_id
  origin   = var.origin
}

resource "cloudfoundry_org_role" "org_auditors" {
  for_each = toset("${var.cf_org_auditors}")
  username = each.value
  type     = "organization_auditor"
  org      = var.cf_org_id
  origin   = var.origin
}


###
# Creation of Cloud Foundry space
###
resource "cloudfoundry_space" "abap_space" {
  name = var.cf_space_name
  org  = var.cf_org_id
}

###
# Assignment of Cloud Foundry org roles 
###
resource "cloudfoundry_space_role" "space_managers" {
  for_each = toset("${var.cf_space_managers}")
  username = each.value
  type     = "space_manager"
  space    = cloudfoundry_space.abap_space.id
  origin   = var.origin
}

resource "cloudfoundry_space_role" "space_developers" {
  for_each = toset("${var.cf_space_developers}")
  username = each.value
  type     = "space_developer"
  space    = cloudfoundry_space.abap_space.id
  origin   = var.origin
}

resource "cloudfoundry_space_role" "space_auditors" {
  for_each = toset("${var.cf_space_auditors}")
  username = each.value
  type     = "space_auditor"
  space    = cloudfoundry_space.abap_space.id
  origin   = var.origin
}

###
# Creation of service instance for ABAP
###
data "cloudfoundry_service_plans" "abap_service_plans" {
  name = "abap"
}

resource "cloudfoundry_service_instance" "abap_si" {
  depends_on   = [cloudfoundry_space_role.space_managers, cloudfoundry_space_role.space_developers]
  name         = local.abap_service_instance_name
  space        = cloudfoundry_space.abap_space.id
  service_plan = data.cloudfoundry_service_plans.abap_service_plans.service_plans[0].id
  type         = "managed"
  parameters = jsonencode({
    admin_email              = "${var.abap_admin_email}"
    is_development_allowed   = "${var.abap_is_development_allowed}"
    sapsystemname            = "${var.abap_sid}"
    size_of_runtime          = "${var.abap_compute_unit_quota}"
    size_of_persistence      = "${var.hana_compute_unit_quota}"
    size_of_persistence_disk = "auto"
    login_attribute          = "email"
  })
  timeouts = {
    create = "4h"
    delete = "4h"
    update = "4h"
  }
}


###
# Creation of service key for ABAP Development Tools (ADT)
###
resource "cloudfoundry_service_credential_binding" "abap_adt_key" {
  type             = "key"
  name             = "${var.abap_sid}_adt_key"
  service_instance = cloudfoundry_service_instance.abap_si.id
}

###
# Creation of service key for COMM Arrangement
###
resource "cloudfoundry_service_credential_binding" "abap_ips_key" {
  type             = "key"
  name             = "${var.abap_sid}_ips_key"
  service_instance = cloudfoundry_service_instance.abap_si.id
  parameters = jsonencode({
    scenario_id = "SAP_COM_0193"
    type        = "basic"
  })
}
