###
# Setup of names in accordance to naming convention
###
locals {
  project_subaccount_name   = "${var.cf_org_name} | ${var.subaccount_name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.cf_org_name}-${var.subaccount_name}-${var.stage}", " ", "-"))
  project_subaccount_cf_org = replace("${var.cf_org_name}_${lower(var.subaccount_name)}-${lower(var.stage)}", " ", "_")
}

###
# Creation of subaccount
###
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "../../modules/btp-cf/btp-cf-env-instance"

  subaccount_id           = btp_subaccount.project.id
  instance_name           = local.project_subaccount_cf_org
  cf_org_name             = local.project_subaccount_cf_org
  cf_org_user             = []
  cf_org_managers         = []
  cf_org_billing_managers = []
  cf_org_auditors         = []
}

###
# Entitlement of subaccount for Alert Notification service - plan "free"
###
resource "btp_subaccount_entitlement" "alert_notification_free" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "alert-notification"
  plan_name     = "free"
}
