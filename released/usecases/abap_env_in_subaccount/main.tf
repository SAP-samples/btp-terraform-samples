###
# Setup of names based on variables
###
locals {
  project_subaccount_cf_org  = var.create_cf_org ? "CF-${var.project_name}-${var.abap_sid}" : ""
  abap_service_instance_name = "abap-${var.abap_sid}"
}

###
# Subscription to the ABAP web access
###
resource "btp_subaccount_subscription" "abap_web_access" {
  subaccount_id = var.subaccount_id
  app_name      = "abapcp-web-router"
  plan_name     = "default"
}


###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  count  = var.create_cf_org ? 1 : 0
  source = "../../modules/environment/cloudfoundry/envinstance_cf"

  subaccount_id           = var.subaccount_id
  instance_name           = local.project_subaccount_cf_org
  environment_label       = "cf-${var.cf_landscape}"
  cf_org_name             = local.project_subaccount_cf_org
  cf_org_managers         = []
  cf_org_billing_managers = []
  cf_org_auditors         = []
}


###
# Creation of CF space
###
module "cloudfoundry_space" {
  count               = var.create_cf_space ? 1 : 0
  source              = "../../modules/environment/cloudfoundry/space_cf"
  cf_org_id           = var.create_cf_org ? module.cloudfoundry_environment[0].cf_org_id : var.cf_org_id
  name                = var.cf_space_name
  cf_space_managers   = var.cf_space_managers
  cf_space_developers = var.cf_space_developers
  cf_space_auditors   = []
}

# Fetch the space data for having one source of the space ID
data "cloudfoundry_space" "cf_space_data" {
  name       = var.cf_space_name
  org        = var.cf_org_id
  depends_on = [module.cloudfoundry_space]
}

###
# Artificial timeout for entitlement propagation to CF Marketplace
###
resource "time_sleep" "wait_a_few_seconds" {
  count           = var.create_cf_space ? 1 : 0
  depends_on      = [data.cloudfoundry_space.cf_space_data]
  create_duration = "30s"
}


###
# Creation of service instance for ABAP
###
data "cloudfoundry_service_plans" "abap_service_plans" {
  name       = "abap"
  depends_on = [time_sleep.wait_a_few_seconds]
}


resource "cloudfoundry_service_instance" "abap_si" {
  name         = local.abap_service_instance_name
  space        = data.cloudfoundry_space.cf_space_data.id
  service_plan = data.cloudfoundry_service_plans.abap_service_plans.service_plans[0].id
  json_params = jsonencode({
    admin_email              = "${var.abap_admin_email}"
    is_development_allowed   = "${var.abap_is_development_allowed}"
    sapsystemname            = "${var.abap_sid}"
    size_of_runtime          = "${var.abap_compute_unit_quota}"
    size_of_persistence      = "${var.hana_compute_unit_quota}"
    size_of_persistence_disk = "auto"
    login_attribute          = "email"
  })
  timeouts {
    create = "2h"
    delete = "2h"
    update = "2h"
  }
}


###
# Creation of service key for ABAP Development Tools (ADT)
###
resource "cloudfoundry_service_key" "abap_adtkey" {
  name             = "${var.abap_sid}_adtkey"
  service_instance = cloudfoundry_service_instance.abap_si.id
}


###
# Creation of service key for COMM Arrangement
###
resource "cloudfoundry_service_key" "abap_ipskey" {
  name             = "${var.abap_sid}_ipskey"
  service_instance = cloudfoundry_service_instance.abap_si.id
  params_json = jsonencode({
    scenario_id = "SAP_COM_0193"
    type        = "basic"
  })
}

###
# Setup Trust Configuration
###
#resource "btp_subaccount_trust_configuration" "subaccount_trust_abap" {
#  subaccount_id     = btp_subaccount.abap-subaccount.id
#  identity_provider = var.custom_idp
#}
