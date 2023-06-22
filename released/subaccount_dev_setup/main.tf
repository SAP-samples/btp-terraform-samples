###
# Setup of names in accordance to naming convention
###
locals {
  project_subaccount_name   = "${var.org_name} | ${var.name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.name}-${var.stage}", " ", "-"))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.name)}-${lower(var.stage)}", " ", "_")
}

###
# Creation of subaccount
###
resource "btp_subaccount" "project" {
  name      = local.project_subaccount_name
  subdomain = local.project_subaccount_domain
  region    = ${lower(var.region)
}

###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "git::https://github.tools.sap/BTP-Terraform/terraform-provider-btp-modules.git//tf_modules_btp/environment/cloud-foundry/envinstance?ref=main"

  subaccount_id         = btp_subaccount.project.id
  instance_name         = local.project_subaccount_cf_org
  cloudfoundry_org_name = local.project_subaccount_cf_org
}

###
# Entitlement of subaccount for Alert Notification service - plan "free"
###
resource "btp_subaccount_entitlement" "alert_notification_free" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "alert-notification"
  plan_name     = "free"
}
