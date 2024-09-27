###############################################################################################
# Generating random ID for subdomain
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "btp-gp${local.random_uuid}"
  subaccount_cf_org = length(var.cf_org_name) > 0 ? var.cf_org_name : substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
}

data "btp_whoami" "me" {}

data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.project.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
###############################################################################################
# Creation of Cloud Foundry environment
###############################################################################################
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project.id
  name             = local.subaccount_cf_org
  landscape_label  = terraform_data.cf_landscape_label.output
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  # ATTENTION: some regions offer multiple environments of a kind and you must explicitly select the target environment in which
  # the instance shall be created using the parameter landscape label. 
  # available environments can be looked up using the btp_subaccount_environments datasource
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "30m"
  }
}

###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}
######################################################################
# Add Build Workzone entitlement
######################################################################
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = var.service_plan__build_workzone
  amount        = var.service_plan__build_workzone == "free" ? 1 : null
}
######################################################################
# Create HANA entitlement subscription
######################################################################
resource "btp_subaccount_entitlement" "hana-cloud" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "hana-cloud"
  plan_name     = var.service_plan__hana_cloud
}
# Enable HANA Cloud Tools
resource "btp_subaccount_entitlement" "hana-cloud-tools" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "hana-cloud-tools"
  plan_name     = "tools"
}
resource "btp_subaccount_subscription" "hana-cloud-tools" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "hana-cloud-tools"
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana-cloud-tools]
}
# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "hana-cloud-admin" {
  for_each             = toset(var.hana_cloud_admins)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.hana-cloud-tools]
}
resource "btp_subaccount_entitlement" "hana-hdi-shared" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "hana"
  plan_name     = "hdi-shared"
}

###############################################################################################
# Prepare and setup app: Continuous Integration & Delivery
###############################################################################################
# Entitle subaccount for usage of app Continuous Integration & Delivery
resource "btp_subaccount_entitlement" "cicd_app" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "cicd-app"
  plan_name     = var.cicd_service_plan
}

locals {
  cf_org_users  = setsubtract(toset(var.cf_org_users), [data.btp_whoami.me.email])
  cf_org_admins = setsubtract(toset(var.cf_org_admins), [data.btp_whoami.me.email])
}

resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_next_stage ? 1 : 0
  content  = <<-EOT
      cf_api_url          = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id           = "${btp_subaccount_environment_instance.cloudfoundry.platform_id}"
      
      cf_org_users        = ${jsonencode(local.cf_org_users)}
      cf_org_admins       = ${jsonencode(local.cf_org_admins)}
      cf_space_developers = ${jsonencode(var.cf_space_developers)}
      cf_space_managers   = ${jsonencode(var.cf_space_managers)}

      EOT
  filename = "../step2_cf/terraform.tfvars"
}