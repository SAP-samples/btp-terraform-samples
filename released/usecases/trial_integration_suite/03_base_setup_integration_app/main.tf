// The app name must be determined dynamically as for integration suite this is not the service name of the entitlement
data "btp_subaccount_subscriptions" "all" {
  subaccount_id = var.subaccount_id
}

locals {
  integrationsuite_trial_subscription = try(
    {
      for subscription in data.btp_subaccount_subscriptions.all.values : subscription.commercial_app_name => subscription
      if subscription.commercial_app_name == "integrationsuite-trial"
    },
    {}
  )
}

resource "btp_subaccount_subscription" "integrationsuite_app_trial" {
  for_each      = local.integrationsuite_trial_subscription
  subaccount_id = var.subaccount_id
  app_name      = each.value.app_name
  plan_name     = "trial"
}

resource "btp_subaccount_role_collection_assignment" "integration_provisioners" {
  for_each             = toset(var.integration_provisioners)
  subaccount_id        = var.subaccount_id
  role_collection_name = "Integration_Provisioner"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.integrationsuite_app_trial]
}
