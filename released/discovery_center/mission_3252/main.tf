# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 3252
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-3260-${local.random_uuid}", "_", "-"))
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count     = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__kymaruntime = "kymaruntime"
}

# ------------------------------------------------------------------------------------------------------
# Setup kymaruntime (Kyma Runtime)
# ------------------------------------------------------------------------------------------------------
#
data "btp_regions" "all" {}

# we take the iaas provider for the first region associated with the subaccount 
locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.dc_mission.region][0].iaas_provider
}
# Entitle
resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__kymaruntime
  plan_name     = lower(local.subaccount_iaas_provider)
  amount        = 1
}

data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_entitlement.kymaruntime]
}

# Take the first kyma region from the first kyma environment if no kyma instance parameters are provided
resource "null_resource" "cache_kyma_region" {
  triggers = {
    region = var.kyma_instance_parameters != null ? var.kyma_instance_parameters.region : jsondecode([for env in data.btp_subaccount_environments.all.values : env if env.service_name == "kymaruntime" && env.environment_type == "kyma" && env.plan_name == lower(local.subaccount_iaas_provider)][0].schema_create).parameters.properties.region.enum[0]
  }

  lifecycle {
    ignore_changes = all
  }
}

locals {
  kyma_instance_parameters = var.kyma_instance_parameters != null ? var.kyma_instance_parameters : {
    name   = data.btp_subaccount.dc_mission.subdomain
    region = null_resource.cache_kyma_region.triggers.region
  }
}

resource "btp_subaccount_environment_instance" "kyma" {
  subaccount_id    = data.btp_subaccount.dc_mission.id
  name             = var.kyma_instance_parameters != null ? var.kyma_instance_parameters.name : data.btp_subaccount.dc_mission.subdomain
  environment_type = "kyma"
  service_name     = local.service_name__kymaruntime
  plan_name        = lower(local.subaccount_iaas_provider)
  parameters       = jsonencode(local.kyma_instance_parameters)
  timeouts         = var.kyma_instance_timeouts
  depends_on       = [btp_subaccount_entitlement.kymaruntime]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Service Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_service_admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}