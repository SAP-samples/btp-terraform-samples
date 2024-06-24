###
# Setup of names based on variables
###
locals {
  subaccount_name   = "${var.subaccount_prefix}-${var.abap_sid}"
  subaccount_domain = lower("${var.subaccount_prefix}-${var.abap_sid}")
  subaccount_cf_org = "CF-${var.subaccount_prefix}-${var.abap_sid}"
}

###
# Creation of subaccount
###
resource "btp_subaccount" "abap_subaccount" {
  name      = local.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
}


###
# Assignment of basic entitlements for an ABAP setup
###
resource "btp_subaccount_entitlement" "abap__service_instance_plan" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = "abap"
  plan_name     = var.abap_si_plan
}

resource "btp_subaccount_entitlement" "abap__abap_compute_unit" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = "abap"
  plan_name     = "abap_compute_unit"
  amount        = var.abap_compute_unit_quota
}

resource "btp_subaccount_entitlement" "abap__hana_compute_unit" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = "abap"
  plan_name     = "hana_compute_unit"
  amount        = var.hana_compute_unit_quota
}

resource "btp_subaccount_entitlement" "abapcp-web-router__default" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = "abapcp-web-router"
  plan_name     = "default"
}

###
# Subscription to the ABAP web access
###
resource "btp_subaccount_subscription" "abap_web_access" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  app_name      = "abapcp-web-router"
  plan_name     = "default"
  depends_on    = [btp_subaccount_entitlement.abapcp-web-router__default]
}


###
# Creation of Cloud Foundry environment
###

# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.abap_subaccount.id
}

# Take the landscape label from the first CF environment if no environment label is provided
resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

# Create the Cloud Foundry environment instance
resource "btp_subaccount_environment_instance" "cf_abap" {
  subaccount_id    = btp_subaccount.abap_subaccount.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.cf_plan_name
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}

###
# Setup Trust Configuration to Custom IdP
###
#resource "btp_subaccount_trust_configuration" "subaccount_trust_abap" {
#  subaccount_id     = btp_subaccount.abap_subaccount.id
#  identity_provider = var.custom_idp
#}
