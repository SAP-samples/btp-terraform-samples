# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 4104
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "subaccount_domain_suffix" {}

locals {
  random_uuid               = random_uuid.subaccount_domain_suffix.result
  subaccount_domain = lower(replace("dcmission-4104-${local.random_uuid}", "_", "-"))
  subaccount_cf_org = substr(replace("cf-${local.random_uuid}", "-", ""), 0, 32)
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
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
resource "terraform_data" "replacement" {
  input = length(var.cf_environment_label) > 0 ? var.cf_environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}
# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = local.subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.replacement.output

  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
# Setup SAP Cloud Transport Management
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "alm" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "alm-ts"
  plan_name     = "standard"
}
# Add subscription
resource "btp_subaccount_subscription" "alm" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "alm-ts"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.alm]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAP Cloud Integration Automation
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "cias" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "cias"
  plan_name     = "standard"
}
# Add subscription
resource "btp_subaccount_subscription" "cias" {
  subaccount_id = btp_subaccount.dc_mission.id
  app_name      = "cias"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.cias]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAP Cloud ALM API
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "sapcloudalmapis" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "SAPCloudALMAPIs"
  plan_name     = "standard"
  amount        = 1
}
# Get serviceplan_id for SAPCloudALMAPIs with plan_name "standard"
data "btp_subaccount_service_plan" "sapcloudalmapis" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = "SAPCloudALMAPIs"
  name          = "standard"
  depends_on    = [btp_subaccount_entitlement.sapcloudalmapis]
}
# Create service instance
resource "btp_subaccount_service_instance" "sapcloudalmapis" {
  subaccount_id  = btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.sapcloudalmapis.id
  name           = "standard_sapcloudalmapis"
  depends_on     = [btp_subaccount_entitlement.sapcloudalmapis, btp_subaccount_environment_instance.cf]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  # origin               = var.custom_idp
  depends_on = [btp_subaccount.dc_mission]
}
