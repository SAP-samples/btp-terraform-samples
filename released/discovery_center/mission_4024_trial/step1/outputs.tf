output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the project subaccount."
}

output "sap_build_apps_subscription_url" {
  value       = btp_subaccount_subscription.sap-build-apps.subscription_url
  description = "The subscription_url of build app."
}