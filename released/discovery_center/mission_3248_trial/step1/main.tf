# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 3248 (trial)
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "dcmission4024${local.random_uuid}"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

data "btp_subaccount" "subaccount" {
  id = data.btp_subaccount.dc_mission.id
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__abap_trial   = "abap-trial"
  service_name__cloudfoundry = "cloudfoundry"
}
# ------------------------------------------------------------------------------------------------------
# Setup abap-trial (ABAP environment)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "abap_trial" {
  subaccount_id = data.btp_subaccount.subaccount.id
  service_name  = local.service_name__abap_trial
  plan_name     = var.service_plan__abap_trial
  amount        = 1
}

# ------------------------------------------------------------------------------------------------------
# Setup cloudfoundry (Cloud Foundry Environment)
# ------------------------------------------------------------------------------------------------------
# Fetch all available environments for the subaccount
# Retrieval of existing CF environment instance
data "btp_subaccount_environment_instances" "all" {
  subaccount_id = data.btp_subaccount.subaccount.id
}

locals {
  cf_org_name     = join("_", [var.globalaccount, data.btp_subaccount.subaccount.subdomain])
  cf_instances    = [for env in data.btp_subaccount_environment_instances.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"]
  cf_enabled      = length(local.cf_instances) > 0
  create_cf_space = var.create_cf_space || !local.cf_enabled
}
# Instance creation (optional)
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  count = local.cf_enabled ? 0 : 1

  subaccount_id    = data.btp_subaccount.subaccount.id
  name             = local.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = local.service_name__cloudfoundry
  plan_name        = var.service_plan__cloudfoundry

  parameters = jsonencode({
    instance_name = local.cf_org_name
  })
}

locals {
  cf_environment_instance = local.cf_enabled ? local.cf_instances[0] : btp_subaccount_environment_instance.cloudfoundry[0]
}

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      cli_server_url       = ${jsonencode(var.cli_server_url)}

      cf_api_url          = "${jsondecode(local.cf_environment_instance.labels)["API Endpoint"]}"
      cf_org_id           = "${local.cf_environment_instance.platform_id}"

      abap_admin_email    = "${var.abap_admin_email}"

      create_cf_space     = ${local.create_cf_space}

      cf_org_managers     = ${jsonencode(var.cf_org_managers)}
      cf_space_developers = ${jsonencode(var.cf_space_developers)}
      cf_space_managers   = ${jsonencode(var.cf_space_managers)}
      cf_space_name       = "${var.cf_space_name}"

      EOT
  filename = "../step2/terraform.tfvars"
}
