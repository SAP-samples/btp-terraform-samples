###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-3252-${local.random_uuid}", "_", "-"))
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

###############################################################################################
# Assignment of users as sub account service administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Setup Kyma
######################################################################
data "btp_regions" "all" {}

#we take the iaas provider for the first region associated with the subaccount 
locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == btp_subaccount.dc_mission.region][0].iaas_provider
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "kymaruntime"
  plan_name     = lower(local.subaccount_iaas_provider)
  amount        = 1
}

data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.dc_mission.id
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
    name   = btp_subaccount.dc_mission.subdomain
    region = null_resource.cache_kyma_region.triggers.region
  }
}

resource "btp_subaccount_environment_instance" "kyma" {
  subaccount_id    = btp_subaccount.dc_mission.id
  name             = var.kyma_instance_parameters != null ? var.kyma_instance_parameters.name : btp_subaccount.dc_mission.subdomain
  environment_type = "kyma"
  service_name     = "kymaruntime"
  plan_name        = lower(local.subaccount_iaas_provider)
  parameters       = jsonencode(local.kyma_instance_parameters)
  timeouts         = var.kyma_instance_timeouts
  depends_on       = [btp_subaccount_entitlement.kymaruntime]
}
