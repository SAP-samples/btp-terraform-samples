###
# Setup of names in accordance to naming convention
###
locals {
  project_subaccount_name   = "${var.org_name} | ${var.name}: CF - ${var.stage}"
  project_subaccount_domain = lower(replace("${var.org_name}-${var.name}-${var.stage}", " ", "-"))
  project_subaccount_cf_org = replace("${var.org_name}_${lower(var.name)}-${lower(var.stage)}", " ", "_")
}

###
# Creation of directory for DEV
###
resource "btp_directory" "landscapes" {
  dynamic "setting" {
    for_each = var.project
    content {
      name        = lower(replace("${var.org_name}-${var.department_name}-${var.stage}", " ", "-"))
      description = "Parent directory for all ${var.stage} landscapes"
    }
  }
}
