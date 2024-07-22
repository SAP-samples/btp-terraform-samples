###
# Retrieval of existing trial subaccount
###
data "btp_subaccount" "trial" {
  id = var.subaccount_id
}

###
# Assignment of basic entitlements for an ABAP setup
###
resource "btp_subaccount_entitlement" "abap-trial" {
  subaccount_id = var.subaccount_id
  service_name  = "abap-trial"
  plan_name     = "shared"
  amount        = 1
}

###
# Retrieval of existing CF environment instance
###
data "btp_subaccount_environment_instances" "all" {
  subaccount_id = var.subaccount_id
}

locals {
  cf_org_name     = join("_", [var.globalaccount, data.btp_subaccount.trial.subdomain])
  cf_instances    = [for env in data.btp_subaccount_environment_instances.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"]
  cf_enabled      = length(local.cf_instances) > 0
  create_cf_space = var.create_cf_space || !local.cf_enabled
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  count = local.cf_enabled ? 0 : 1

  subaccount_id    = var.subaccount_id
  name             = local.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "trial"

  parameters = jsonencode({
    instance_name = local.cf_org_name
  })
}

locals {
  cf_environment_instance = local.cf_enabled ? local.cf_instances[0] : btp_subaccount_environment_instance.cloudfoundry[0]
}

resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_next_stage ? 1 : 0
  content  = <<-EOT
      cf_api_url          = "${jsondecode(local.cf_environment_instance.labels)["API Endpoint"]}"
      cf_org_id           = "${local.cf_environment_instance.platform_id}"
      cf_org_managers     = ${jsonencode(var.cf_org_managers)}
      cf_space_developers = ${jsonencode(var.cf_space_developers)}
      cf_space_managers   = ${jsonencode(var.cf_space_managers)}
      cf_space_name       = "${var.cf_space_name}"
      create_cf_space     = ${local.create_cf_space}
      abap_admin_email    = "${var.abap_admin_email}"

      EOT
  filename = "../step2/terraform.tfvars"
}
