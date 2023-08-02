######################################################################
# Entitlement for app subscription
######################################################################
resource "btp_subaccount_entitlement" "name" {
  subaccount_id = var.subaccount_id
  service_name  = var.name
  plan_name     = var.plan
}
######################################################################
# Create app subscriptions
######################################################################
resource "btp_subaccount_subscription" "sapappstudio" {
  subaccount_id = var.subaccount_id
  app_name      = var.name
  plan_name     = var.plan
  depends_on    = [btp_subaccount_entitlement.name]
}
