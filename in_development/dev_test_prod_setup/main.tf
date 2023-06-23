/*
###
# Creation of landscape directories
###
resource "btp_directory" "landscapes" {
  for_each = var.project
    name        = upper(replace("${each.value.stage}", " ", "-"))
    description = "Parent directory for all ${each.value.stage} landscapes"
}
*/

###
# Creation of subaccounts
###
resource "btp_subaccount" "subaccount" {

  for_each = var.project
    name      = "${each.value.stage} - ${var.org_name}: ${var.department_name}"
    subdomain = lower(replace("${each.value.stage}-${var.org_name}-${var.department_name}", " ", "-"))
    region    = var.region
    #labels    = [{"costcenter": ["${var.costcenter}"]} ]
}

/*
###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "./modules/envinstance-cloudfoundry/"

  for_each = {}
    subaccount_id         = btp_subaccount.subaccount.id
    instance_name         = lower(replace("${each.value.stage}_${var.org_name}_${var.department_name}", " ", "_"))
    cloudfoundry_org_name = lower(replace("${each.value.stage}_${var.org_name}_${var.department_name}", " ", "_"))
}


###
# Add entitlements to each subaccount
###
resource "btp_subaccount_entitlement" "all_entitlements" {
  subaccount_id = btp_subaccount.subaccount.id

  for_each = var.entitlements
    service_name  = each.value.service_name
    plan_name     = each.value.plan_name
}
*/
