output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount where dc mission is set up."
}

output "build_code_subscription_url" {
  value       = btp_subaccount_subscription.build_code.subscription_url
  description = "SAP Build Code subscription URL."
}
