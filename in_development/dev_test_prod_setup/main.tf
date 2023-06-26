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
resource "btp_subaccount" "all" {

  for_each = var.project
    name      = "${each.value.stage} - ${var.org_name}: ${var.department_name}"
    subdomain = lower(replace("${each.value.stage}-${var.org_name}-${var.department_name}", " ", "-"))
    region    = lower(var.region)
    #labels    = [{"costcenter": ["${var.costcenter}"]} ]

}

###
# Creation of Cloud Foundry environment
###
module "cloudfoundry_environment" {
  source = "./modules/envinstance-cloudfoundry/"

  for_each = btp_subaccount.all
    subaccount_id         = each.value.id
    instance_name         = substr(replace(lower(replace("${each.value.name}", "/\\W|_|\\s/" , "_")), "__", "_"), 0, 32)
    cloudfoundry_org_name = replace(lower(replace("${each.value.name}", "/\\W|_|\\s/" , "_")), "__", "_")
}

/*
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
