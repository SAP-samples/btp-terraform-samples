###
# Setup of names in accordance to naming convention
###
locals {
  random_uuid = uuid()  
  project_subaccount_domain = "ucresilientapps${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""),0,32)
}

######################################################################
# Entitle and create service instances
######################################################################
module "service_instances" {
  source        = "./modules/cf-service-instance/"
  subaccount_id = btp_subaccount.project.id

  for_each   = {
    for index, entitlement in var.entitlements:
    index => entitlement if contains(["service"], entitlement.type)
 }
    name        = each.value.service_name
    plan        = each.value.plan_name
    parameters  = each.value.parameters
    cf_org_id   = var.cf_org_id
}
