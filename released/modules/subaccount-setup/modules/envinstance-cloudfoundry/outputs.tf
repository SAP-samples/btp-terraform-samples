output "cf_env_instance_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.id
  description = "ID of the Cloud Foundry environment instance."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
  description = "ID of the Cloud Foundry org."
}

output "cf_api_endpoint" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}
