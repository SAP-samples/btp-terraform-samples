output "subaccount_id" {
  value       = btp_subaccount.subaccount.id
  description = "Technical ID of the subaccount."
}

output "cf_env_instance_id" {
  value       = one(module.cloudfoundry_environment[*].cf_env_instance_id)
  description = "ID of the Cloud Foundry environment instance."
}

output "cf_org_id" {
  value       = one(module.cloudfoundry_environment[*].cf_org_id)
  description = "ID of the Cloud Foundry org."
}

output "cf_api_endpoint" {
  value       = one(module.cloudfoundry_environment[*].cf_api_endpoint)
  description = "API endpoint of the Cloud Foundry environment."
}



