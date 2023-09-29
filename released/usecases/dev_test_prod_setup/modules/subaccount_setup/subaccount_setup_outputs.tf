output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}

output "cloudfoundry_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the cloudfoundry org connected to the project account."
}

output "cloudfoundry_org_id" {
  value       = module.cloudfoundry_environment.cf_org_id
  description = "The ID of the cloudfoundry org connected to the project account."
}