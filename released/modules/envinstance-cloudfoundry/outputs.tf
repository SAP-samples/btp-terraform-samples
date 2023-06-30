output "id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.id
  description = "The technical ID of the Cloud Foundry environment instance."
}

output "org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id 
  description = "The technical ID of the Cloud Foundry environment instance."
}

output "api_endpoint" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
  description = "The API endpoint of the Cloud Foundry environment."
}

output "state" {
  value       = btp_subaccount_environment_instance.cloudfoundry.state
  description = "State of the Cloud Foundry environment."
}

output "created_date" {
  value       = btp_subaccount_environment_instance.cloudfoundry.created_date
  description = "The time the resource was created (ISO 8601 format)."
}

output "last_modified" {
  value       = btp_subaccount_environment_instance.cloudfoundry.last_modified
  description = "The last time the resource was updated (ISO 8601 format)."
}
