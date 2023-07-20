locals{
  landscapes       = ["DEV", "TST", "PRD"]
  unit             = "Test"
  unit_shortname   = "tst"
  architect        = "jane.doe@test.com"
  costcenter       = "1234567890"
  customercontact  = "customer.contact@test.com"
  owner            = "john.doe@test.com"
  team             = "sap.team@test.com"
  custom_idp       = "terraformint.accounts400.ondemand.com"
  emergency_admins = ["jane.doe@test.com", "john.doe@test.com"]
}

###
# Creation of directory
###
resource "btp_directory" "parent" {
  name        = "${local.unit}"
  description = "This is the parent directory for ${local.unit}."
  labels      = { "architect": ["${local.architect}"], "costcenter": ["${local.costcenter}"], "owner": ["${local.owner}"], "team": ["${local.team}"]}
}

###
# Call module for creating subaccoun
###
module "project_setup" {
  for_each = toset("${local.landscapes}")
    stage     = each.value
    region    = "eu12"
    source    = "./uc_subaccount_setup/"

    unit                = "${local.unit}"
    unit_shortname      = "${local.unit_shortname}"
    architect           = "${local.architect}"
    costcenter          = "${local.costcenter}"
    owner               = "${local.owner}"
    team                = "${local.team}"
    custom_idp          = "${local.custom_idp}"
    emergency_admins    = "${local.emergency_admins}"
    parent_directory_id = btp_directory.parent.id
}
