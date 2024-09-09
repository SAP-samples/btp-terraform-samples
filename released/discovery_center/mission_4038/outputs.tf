output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "integrationsuite_url" {
  value       = btp_subaccount_subscription.sap_integration_suite.subscription_url
  description = "Subscription URL for SAP Integration Suite."
}
