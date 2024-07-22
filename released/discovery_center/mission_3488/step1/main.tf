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
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------

# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
}

# Take the landscape label from the first CF environment if no environment label is provided
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}

# Create the Cloud Foundry environment instance
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.cf_plan_name
  landscape_label  = terraform_data.cf_landscape_label.output

  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}


resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_next_stage ? 1 : 0
  content  = <<-EOT
     origin               = "${var.origin}"

     cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
     cf_org_id            = "${btp_subaccount_environment_instance.cloudfoundry.platform_id}"

     cf_org_auditors             = ${jsonencode(var.cf_org_auditors)}
     cf_org_billing_managers     = ${jsonencode(var.cf_org_billing_managers)}
     cf_org_admins               = ${jsonencode(var.cf_org_admins)}
     cf_space_auditors           = ${jsonencode(var.cf_space_auditors)}
     cf_space_developers         = ${jsonencode(var.cf_space_developers)}
     cf_space_managers           = ${jsonencode(var.cf_space_managers)}

     service_plan__sac          = "${var.service_plan__sac}"

     sac_param_first_name = "${var.sac_param_first_name}"
     sac_param_last_name  = "${var.sac_param_last_name}"
     sac_param_email      = "${var.sac_param_email}"
     sac_param_host_name  = "${var.sac_param_host_name}"
     
     sac_param_number_of_business_intelligence_licenses = ${var.sac_param_number_of_business_intelligence_licenses}
     sac_param_number_of_professional_licenses          = ${var.sac_param_number_of_professional_licenses}
     sac_param_number_of_business_standard_licenses     = ${var.sac_param_number_of_business_standard_licenses}

      EOT
  filename = "../step2/terraform.tfvars"
}
