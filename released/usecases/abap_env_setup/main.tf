###
# Setup of names based on variables
###
locals {
  project_subaccount_domain  = lower("abap-env-${var.subaccount_name}")
  project_subaccount_cf_org  = "CF-ABAP-${var.abap_sid}"
  abap_service_instance_name = "abap-${var.abap_sid}"
}

###
# Creation of subaccount
###
resource "btp_subaccount" "abap-subaccount" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}


###
# Assignment of basic entitlements for an ABAP setup
###
resource "btp_subaccount_entitlement" "abap__standard" {
  subaccount_id = btp_subaccount.abap-subaccount.id
  service_name  = "abap"
  plan_name     = "standard"
}

resource "btp_subaccount_entitlement" "abap__abap_compute_unit" {
  subaccount_id = btp_subaccount.abap-subaccount.id
  service_name  = "abap"
  plan_name     = "abap-compute-unit"
  amount        = 1
}

resource "btp_subaccount_entitlement" "abap__hana_compute_unit" {
  subaccount_id = btp_subaccount.abap-subaccount.id
  service_name  = "abap"
  plan_name     = "hana-compute-unit"
  amount        = 2
}

resource "btp_subaccount_entitlement" "abapcp-web-router__default" {
  subaccount_id = btp_subaccount.abap-subaccount.id
  service_name  = "abapcp-web-router"
  plan_name     = "default"
}


###
# Setup Trust Configuration
###
resource "btp_subaccount_trust_configuration" "subaccount_trust_abap" {
  subaccount_id     = btp_subaccount.abap-subaccount.id
  identity_provider = var.custom_idp
}


###
# Subscription to the ABAP web access
###
resource "btp_subaccount_subscription" "abap_web_access" {
  subaccount_id = btp_subaccount.abap-subaccount.id
  app_name      = "abapcp-web-router"
  plan_name     = "default"
}


###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "../../modules/environment/cloudfoundry/envinstance_cf"

  subaccount_id           = btp_subaccount.abap-subaccount.id
  instance_name           = local.project_subaccount_cf_org
  cf_org_name             = local.project_subaccount_cf_org
  cf_org_managers         = []
  cf_org_billing_managers = []
  cf_org_auditors         = []
}


###
# Creation of CF space
###
module "cloudfoundry_space" {
  source              = "../../modules/environment/cloudfoundry/space_cf"
  cf_org_id           = module.cloudfoundry_environment.cf_org_id
  name                = var.cf_space_name
  cf_space_managers   = []
  cf_space_developers = []
  cf_space_auditors   = []
}


###
# Artificial timeout for entitlement propagation to CF Marketplace
###
resource "time_sleep" "wait_a_few_seconds" {
  depends_on      = [module.cloudfoundry_space]
  create_duration = "30s"
}


###
# Creation of service instance for ABAP
###
data "cloudfoundry_service" "abap_service_plans" {
  name = "abap"
}

resource "cloudfoundry_service_instance" "abap_si" {
  name         = local.abap_service_instance_name
  space        = cloudfoundry_space.dev.id
  service_plan = data.cloudfoundry_service.abap_service_plans.service_plans["default"]
  json_params = jsonencode({
    admin_email              = "${var.admin_email}"
    is_development_allowed   = "true"
    sapsystemname            = "${var.abap_sid}"
    size_of_runtime          = "1"
    size_of_persistence      = "2"
    size_of_persistence_disk = "auto"
    login_attribute          = "email"
  })
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
resource "cloudfoundry_service_key" "abap_adtkey" {
  name             = "${var.abap_sid}_adtkey"
  service_instance = cloudfoundry_service_instance.abap_si.id
  params_json = jsonencode({
    scenario_id = "SAP_COM_0193"
    type        = "basic"
  })
}