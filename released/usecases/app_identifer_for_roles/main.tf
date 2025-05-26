resource "btp_subaccount" "self" {
  name      = "My Dev Project"
  subdomain = "my-dev-project"
  region    = var.region
}

resource "btp_subaccount_entitlement" "auditlog-management_default" {
  subaccount_id = btp_subaccount.self.id
  service_name  = "auditlog-management"
  plan_name     = "default"
}

data "btp_subaccount_service_plan" "auditlog_default" {
  name          = "default"
  offering_name = "auditlog-management"
  subaccount_id = btp_subaccount.self.id

  depends_on = [btp_subaccount_entitlement.auditlog-management_default]
}

resource "btp_subaccount_service_instance" "auditlog_default" {
  name           = "auditlog-default-dev"
  serviceplan_id = data.btp_subaccount_service_plan.auditlog_default.id
  subaccount_id  = btp_subaccount.self.id
}

data "btp_subaccount_apps" "all" {
  subaccount_id = btp_subaccount.self.id

  depends_on = [btp_subaccount_service_instance.auditlog_default]
}

locals {
  app_id = try(
    { for app in data.btp_subaccount_apps.all.values : app.xsappname => app.id
    if app.xsappname == "auditlog-management" }
  )
}

resource "btp_subaccount_role_collection" "auditlog-viewer" {

  description = "Audit Log Viewer Role Collection"
  name        = "Audit Log Viewer"
  roles = [
    {
      name                 = "Auditlog_Auditor"
      role_template_app_id = local.app_id.auditlog-management
      role_template_name   = "Auditlog_Auditor"
    },
  ]
  subaccount_id = btp_subaccount.self.id

  depends_on = [data.btp_subaccount_apps.all]
}
