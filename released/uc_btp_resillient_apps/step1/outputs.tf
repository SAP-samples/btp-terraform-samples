output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "org_id" {
  value       = module.cloudfoundry_environment.org_id
  description = "The Cloudfoundry org ID."
}

output "api_endpoint" {
  value       = module.cloudfoundry_environment.api_endpoint
  description = "The url of the Cloudfoundry API endpoint."
}