output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}


output "cloudfoundry_environment" {
  value       = module.cloudfoundry_environment
  description = "The metadata from the generated Cloudfoundry environment instance."
}
