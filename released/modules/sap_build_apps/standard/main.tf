resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = var.subaccount_id
  app_name      = "sap-appgyver-ee"
  plan_name     = "standard"
}
