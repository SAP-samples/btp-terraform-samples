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
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

###############################################################################################
# Assignment of users as sub account service administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Setup Kyma
######################################################################
data "btp_regions" "all" {}

#we take the iaas provider for the first region associated with the subaccount 
locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == btp_subaccount.project.region][0].iaas_provider
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "kymaruntime"
  plan_name     = lower(local.subaccount_iaas_provider)
  amount        = 1
}

resource "btp_subaccount_environment_instance" "kyma" {
  subaccount_id    = btp_subaccount.project.id
  name             = var.kyma_instance.name
  environment_type = "kyma"
  service_name     = "kymaruntime"
  plan_name        = lower(local.subaccount_iaas_provider)
  parameters = jsonencode({
    name            = var.kyma_instance.name
    region          = var.kyma_instance.region
    machine_type    = var.kyma_instance.machine_type
    auto_scaler_min = var.kyma_instance.auto_scaler_min
    auto_scaler_max = var.kyma_instance.auto_scaler_max
  })
  timeouts = {
    create = var.kyma_instance.createtimeout
    update = var.kyma_instance.updatetimeout
    delete = var.kyma_instance.deletetimeout
  }
  depends_on = [btp_subaccount_entitlement.kymaruntime]
}
