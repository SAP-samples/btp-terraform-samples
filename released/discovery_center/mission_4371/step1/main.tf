# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-4356-${local.random_uuid}", "_", "-"))
  # If a cf_org_name was defined by the user, take that as a subaccount_cf_org. Otherwise create it.
  subaccount_cf_org = length(var.cf_org_name) > 0 ? var.cf_org_name : substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
}
# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}
# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}


# ------------------------------------------------------------------------------------------------------
# Prepare & setup the SAP AI Core service (ensure your global account has the respective entitlements)
# ------------------------------------------------------------------------------------------------------

# Entitle subaccount for usage of SAP AI Core service
# ------------------------------------------------------------------------------------------------------
# Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for 
# available plans and their region availability 
resource "btp_subaccount_entitlement" "ai_core" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "aicore"
  plan_name     = var.ai_core_plan_name
}

# Get plan for SAP AI Core service
data "btp_subaccount_service_plan" "ai_core" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = "aicore"
  name          = var.ai_core_plan_name
  depends_on    = [btp_subaccount_entitlement.ai_core]
}

# Create service instance for SAP AI Core service
resource "btp_subaccount_service_instance" "ai_core" {
  subaccount_id  = btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.ai_core.id
  name           = "my-ai-core-instance"
  depends_on     = [btp_subaccount_entitlement.ai_core]
}

# Create service binding to SAP AI Core service (exposed for a specific user group)
resource "btp_subaccount_service_binding" "ai_core_binding" {
  subaccount_id       = btp_subaccount.dc_mission.id
  service_instance_id = btp_subaccount_service_instance.ai_core.id
  name                = "ai-core-key"
}


# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud tools
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "hana-cloud-tools"
  plan_name     = "tools"
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "hana-cloud-tools"
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin" {
  for_each             = toset(var.hana_cloud_admins)
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}

# Get plan for SAP HANA Cloud
data "btp_subaccount_service_plan" "hana_cloud" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = "hana-cloud"
  name          = "hana"
  depends_on    = [btp_subaccount_entitlement.hana_cloud]
}

resource "btp_subaccount_service_instance" "hana_cloud" {
  subaccount_id  = btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
  name           = "my-hana-cloud-instance"
  depends_on     = [btp_subaccount_entitlement.hana_cloud]
  parameters = jsonencode(
    {
      "data" : {
        "memory" : 32,
        "edition" : "cloud",
        "systempassword" : "${var.hana_system_password}",
        "additionalWorkers" : 0,
        "disasterRecoveryMode" : "no_disaster_recovery",
        "enabledservices" : {
          "docstore" : false,
          "dpserver" : true,
          "scriptserver" : false
        },
        "requestedOperation" : {},
        "serviceStopped" : false,
        "slaLevel" : "standard",
        "storage" : 120,
        "vcpu" : 2,
        "whitelistIPs" : ["0.0.0.0/0"]
      }
  })

  timeouts = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

# Create service binding to SAP HANA Cloud service 
resource "btp_subaccount_service_binding" "hana_cloud" {
  subaccount_id       = btp_subaccount.dc_mission.id
  service_instance_id = btp_subaccount_service_instance.hana_cloud.id
  name                = "hana-cloud-key"
}



# ------------------------------------------------------------------------------------------------------
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.cf_landscape_label.output
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}
# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      subaccount_id        = "${btp_subaccount.dc_mission.id}"
      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"
      cf_org_id            = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
      origin               = "${var.origin}"
      cf_space_name        = "${var.cf_space_name}"
      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_org_users         = ${jsonencode(var.cf_org_users)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}
      EOT
  filename = "../step2/terraform.tfvars"
}