###
# Setup of names based on variables
###
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower("${var.subaccount_prefix}-${var.abap_sid}-${local.random_uuid}")
  subaccount_name   = var.subaccount_name != "" ? var.subaccount_name : "${var.subaccount_prefix}-${var.abap_sid}"
  subaccount_cf_org = substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
  abap_admin_email  = var.abap_admin_email != "" ? var.abap_admin_email : (length(var.qas_abap_admin) > 0 ? var.qas_abap_admin[0] : "")
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
  service_name  = local.service_name__abap
  plan_name     = var.service_plan__abap
}

resource "btp_subaccount_entitlement" "abap__abap_compute_unit" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = local.service_name__abap
  plan_name     = "abap_compute_unit"
  amount        = var.abap_compute_unit_quota
}

resource "btp_subaccount_entitlement" "abap__hana_compute_unit" {
  subaccount_id = btp_subaccount.abap_subaccount.id
  service_name  = local.service_name__abap
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
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}

# Create the Cloud Foundry environment instance
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.abap_subaccount.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.cf_plan_name
  landscape_label  = terraform_data.cf_landscape_label.output

  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}

###
# Setup Trust Configuration to Custom IdP
###
resource "btp_subaccount_trust_configuration" "subaccount_trust_abap" {
  subaccount_id     = btp_subaccount.abap_subaccount.id
  identity_provider = var.custom_idp
}

resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_next_stage ? 1 : 0
  content  = <<-EOT
      origin               = "${var.origin}"

      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id            = "${btp_subaccount_environment_instance.cloudfoundry.platform_id}"

      cf_org_auditors             = ${jsonencode(var.cf_org_auditors)}
      cf_org_billing_managers     = ${jsonencode(var.cf_org_billing_managers)}
      cf_org_managers             = ${jsonencode(var.cf_org_managers)}
      cf_space_auditors           = ${jsonencode(var.cf_space_auditors)}
      cf_space_developers         = ${jsonencode(var.cf_space_developers)}
      cf_space_managers           = ${jsonencode(var.cf_space_managers)}

      abap_sid                    = "${var.abap_sid}"
      service_plan__abap          = "${var.service_plan__abap}"
      abap_compute_unit_quota     = ${jsonencode(var.abap_compute_unit_quota)}
      hana_compute_unit_quota     = ${jsonencode(var.hana_compute_unit_quota)}
      abap_admin_email            = "${local.abap_admin_email}"
      abap_is_development_allowed = ${var.abap_is_development_allowed}

      EOT
  filename = "../step2/terraform.tfvars"
}
