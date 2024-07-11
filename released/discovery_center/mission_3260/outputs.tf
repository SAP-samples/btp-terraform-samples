output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "bpa_url" {
  value       = btp_subaccount_subscription.build_process_automation.subscription_url
  description = "Subscription URL for SAP Business Process Automation"
}
