output "subaccount_id" {
  value       = data.btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "sap_build_app_subscription_url" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.subscription_url
  description = "The subscription_url of build app."
}