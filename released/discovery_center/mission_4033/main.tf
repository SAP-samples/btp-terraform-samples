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
# Add "sleep" resource for generic purposes
######################################################################
resource "time_sleep" "wait_a_few_seconds" {
  create_duration = "30s"
}

######################################################################
# Setup Kyma
######################################################################
data "btp_regions" "all" {}

locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.this.region][0].iaas_provider
}

data "btp_subaccount" "this" {
  id = btp_subaccount.project.id
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = btp_subaccount.project.id
  service_name = "kymaruntime"
  plan_name    = lower(local.subaccount_iaas_provider)
  amount       = 1
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
  depends_on = [ btp_subaccount_entitlement.kymaruntime ]
}

# module "sap_kyma_instance" {
#   source            = "../../../in-development/modules/envinstance-kyma"
#   subaccount_id     = btp_subaccount.project.id
#   name              = var.kyma_instance.name
# }


######################################################################
# Entitlement of all services
######################################################################
resource "btp_subaccount_entitlement" "name" {
  depends_on = [time_sleep.wait_a_few_seconds]
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

######################################################################
# Create app subscriptions
######################################################################
data"btp_subaccount_subscriptions" "all"{
  subaccount_id = btp_subaccount.project.id
  depends_on = [ btp_subaccount_entitlement.name ]
}

resource "btp_subaccount_subscription" "app" {
  subaccount_id = btp_subaccount.project.id
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement if contains(["app"], entitlement.type)
  }
  app_name   = [
    for subscription in data.btp_subaccount_subscriptions.all.values: 
    subscription 
    if subscription.commercial_app_name == each.value.service_name
  ][0].app_name
  plan_name  = each.value.plan_name
  depends_on = [data.btp_subaccount_subscriptions.all]
}

######################################################################
# Assign Role Collection
######################################################################

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.conn_dest_admin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "int_prov" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.int_provisioner)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationAdmin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationAdmin)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.app]
  for_each             = toset(var.ProcessAutomationParticipant)
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
}

######################################################################
# Assign custom IDP to sub account
######################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  subaccount_id     = btp_subaccount.project.id
  identity_provider = var.custom_idp
  depends_on = [ btp_subaccount.project.id ]
}

######################################################################
# Create app subscription to SAP Build Apps (depends on entitlement)
######################################################################
module "sap-build-apps_standard" {
  source            = "../../modules/services_apps/sap_build_apps/standard"
  subaccount_id     = btp_subaccount.project.id
  subaccount_domain = btp_subaccount.project.subdomain
  region            = var.region
  custom_idp_origin = btp_subaccount_trust_configuration.fully_customized.origin
  users_BuildAppsAdmin     = var.users_BuildAppsAdmin
  users_BuildAppsDeveloper = var.users_BuildAppsDeveloper
  users_RegistryAdmin      = var.users_RegistryAdmin
  users_RegistryDeveloper  = var.users_RegistryDeveloper
  depends_on               = [btp_subaccount_trust_configuration.fully_customized, btp_subaccount_entitlement.name]
}
