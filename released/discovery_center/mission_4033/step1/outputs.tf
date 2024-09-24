output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the project subaccount."
}

output "integration_suite_url" {
  value = btp_subaccount_subscription.sap_integration_suite.subscription_url
}

output "process_automation_subscription_url" {
  value       = btp_subaccount_subscription.build_process_automation.subscription_url
  description = "Subscription URL for SAP Build Process Automation"
}

output "kyma_url" {
  value       = btp_subaccount_environment_instance.kyma.dashboard_url
  description = "Subscription URL for SAP Build Process Automation"
}