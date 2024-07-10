output "subaccount_id" {

  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
  description = "The Cloudfoundry org ID."
}

output "bpa_url" {
  value       = btp_subaccount_subscription.bpa.subscription_url
  description = "Subscription URL for SAP Business Process Automation"
}
