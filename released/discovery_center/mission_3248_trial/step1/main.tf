###
# Assignment of basic entitlements for an ABAP setup
###
resource "btp_subaccount_entitlement" "abap-trial" {
  subaccount_id = var.subaccount_id
  service_name  = "abap-trial"
  plan_name     = "shared"
}

# Create the Cloud Foundry environment instance
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  count = var.cf_org_id == "" ? 1 : 0

  subaccount_id    = var.subaccount_id
  name             = var.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "trial"

  parameters = jsonencode({
    instance_name = var.cf_org_name
  })
}

resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_next_stage ? 1 : 0
  content  = <<-EOT
      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id            = "${btp_subaccount_environment_instance.cf_abap.platform_id}"

      cf_space_developers         = ${jsonencode(var.cf_space_developers)}
      cf_space_managers           = ${jsonencode(var.cf_space_managers)}

      abap_admin_email            = "${local.abap_admin_email}"
      abap_is_development_allowed = ${var.abap_is_development_allowed}

      EOT
  filename = "../step2/terraform.tfvars"
}
