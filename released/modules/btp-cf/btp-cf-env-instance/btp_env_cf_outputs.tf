output "cf_env_instance_id" {
  value       = btp_subaccount_environment_instance.cf.id
  description = "ID of the Cloud Foundry environment instance."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cf.platform_id
  description = "ID of the Cloud Foundry org."
}

output "cf_api_endpoint" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cf.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}