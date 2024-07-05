# ------------------------------------------------------------------------------------------------------
# Setup of names based on variables
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower("${var.subaccount_name}-${local.random_uuid}")
  subaccount_name   = var.subaccount_name
  subaccount_cf_org = substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = join("-", ["dc-mission-3488", random_uuid.uuid.result])
  region    = lower(var.region)
}


# ------------------------------------------------------------------------------------------------------
# Assignment of basic entitlements for an SAC setup
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "sac__service_instance_plan" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = local.service_name__sac
  plan_name     = var.service_plan__sac
}

# ------------------------------------------------------------------------------------------------------
# Creation of service instance for SAP Analytics Bloud
# ------------------------------------------------------------------------------------------------------
# Fetch service plan id
data "btp_subaccount_service_plan" "sac_si" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = local.service_name__sac
  name          = var.service_plan__sac
  depends_on    = [btp_subaccount_entitlement.sac__service_instance_plan]
}
# create service instance
resource "btp_subaccount_service_instance" "sac_si" {
  name           = "sac_instance"
  serviceplan_id = data.btp_subaccount_service_plan.sac_si.id
  subaccount_id  = btp_subaccount.dc_mission.id
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
