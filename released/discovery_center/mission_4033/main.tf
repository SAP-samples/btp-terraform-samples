###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-4033-${local.random_uuid}", "_", "-"))
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
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
# Assign custom IDP to sub account
######################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
  depends_on        = [btp_subaccount.project]
}


######################################################################
# Setup Kyma
######################################################################
data "btp_regions" "all" {}

data "btp_subaccount" "this" {
  id = btp_subaccount.project.id
}

locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.this.region][0].iaas_provider
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
  plan_name        = "aws"
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

######################################################################
# Entitlement of all services
######################################################################
resource "btp_subaccount_entitlement" "name" {
  depends_on = [btp_subaccount.project]
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}


######################################################################
# Create App Subscriptions
######################################################################
module "create_app_subscriptions" {
  source            = "./app_susbscriptions"
  btp_subaccount_id = btp_subaccount.project.id
  subdomain         = btp_subaccount.project.subdomain
  custom_idp_origin = btp_subaccount_trust_configuration.fully_customized.origin
  entitlements      = var.entitlements
  region            = var.region
  kyma_instance     = var.kyma_instance

  int_provisioner              = var.int_provisioner
  conn_dest_admin              = var.conn_dest_admin
  users_BuildAppsAdmin         = var.users_BuildAppsAdmin
  users_BuildAppsDeveloper     = var.users_BuildAppsDeveloper
  users_RegistryAdmin          = var.users_RegistryAdmin
  users_RegistryDeveloper      = var.users_RegistryDeveloper
  ProcessAutomationAdmin       = var.ProcessAutomationAdmin
  ProcessAutomationDeveloper   = var.ProcessAutomationDeveloper
  ProcessAutomationParticipant = var.ProcessAutomationParticipant

  depends_on = [btp_subaccount_entitlement.name]
}
