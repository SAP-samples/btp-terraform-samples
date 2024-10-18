###############################################################################################
# Generating random ID for subdomain
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "memory-${local.random_uuid}"
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

resource "btp_subaccount_entitlement" "cf_application_runtime" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "APPLICATION_RUNTIME"
  plan_name     = "MEMORY"
  amount        = 1
}
###############################################################################################
# Creation of Cloud Foundry environment
###############################################################################################
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  depends_on       = [btp_subaccount_entitlement.cf_application_runtime]
  subaccount_id    = btp_subaccount.project.id
  name             = local.subaccount_cf_org
  landscape_label  = var.cf_landscape_label
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  # ATTENTION: some regions offer multiple environments of a kind and you must explicitly select the target environment in which
  # the instance shall be created using the parameter landscape label. 
  # available environments can be looked up using the btp_subaccount_environments datasource
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
    memory        = 1024
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
