output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the dc mission subaccount."
}

output "process_automation_subscription_url" {
  value       = btp_subaccount_subscription.build_process_automation.subscription_url
  description = "Subscription URL for SAP Build Process Automation"
}
