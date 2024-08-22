output "globalaccount" {
  value       = var.globalaccount
  description = "The Global Account subdomain."
}

output "cli_server_url" {
  value       = var.cli_server_url
  description = "The BTP CLI server URL."
}

output "subaccount_id" {
  value       = terraform_data.dc_mission_subaccount.output.id
  description = "The Global Account subdomain id."
}

output "build_code_subscription_url" {
  value       = btp_subaccount_subscription.build_code.subscription_url
  description = "SAP Build Code subscription URL."
}
