###
# Creation of subaccounts
###
resource "btp_subaccount" "all" {

  for_each = var.project
    name      = "${each.value.stage} - ${var.org_name}: ${var.department_name} (${var.project_name})"
    subdomain = lower(replace("${each.value.stage}-${var.org_name}-${var.department_name}-${var.project_name}", " ", "-"))
    region    = lower(var.region)
    labels    = {"costcenter": ["${var.costcenter}"]}
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
