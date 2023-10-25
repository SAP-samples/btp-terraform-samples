output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "org_id" {
  value       = module.cloudfoundry_environment.cf_org_id
  description = "The Cloudfoundry org ID."
}
