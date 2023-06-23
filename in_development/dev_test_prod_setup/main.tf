###
# Setup of names in accordance to naming convention
###
/*
locals {
  project_subaccount_name   = "${var.org_name} | ${var.name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.name}-${var.stage}", " ", "-"))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.name)}-${lower(var.stage)}", " ", "_")
}*/

###
# Creation of directory for DEV
###
resource "btp_directory" "landscapes" {
  for_each = var.project
    name        = upper(replace("${each.value.stage}", " ", "-"))
    description = "Parent directory for all ${each.value.stage} landscapes"
}

###
# Creation of subaccounts
###
resource "btp_subaccount" "project" {

  for_each = var.project
    name      = "${var.org_name} | ${var.department_name}: CF - ${each.value.stage}"
    subdomain = lower(replace("${var.org_name}-${var.department_name}-${each.value.stage}", " ", "-"))
    region    = lower(var.region)
}
