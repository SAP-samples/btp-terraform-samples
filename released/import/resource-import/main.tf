resource "btp_subaccount" "my_imported_subaccount" {
  name      = var.subaccount_name
  subdomain = var.subaccount_subdomain
  region    = var.subaccount_region
  usage     = var.subaccount_usage
  labels    = var.subaccount_labels
}

resource "btp_subaccount_entitlement" "my_imported_entitlement" {
  subaccount_id = btp_subaccount.my_imported_subaccount.id
  service_name  = var.service_name
  plan_name     = var.service_plan_name
}
