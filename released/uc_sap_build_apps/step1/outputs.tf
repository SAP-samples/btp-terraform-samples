output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}

output "cf_org_id" {
  value       = module.cloudfoundry_environment.org_id
  description = "The org ID of the Cloudfoundry environment instance."
}

output "cf_api_endpoint" {
  value       = module.cloudfoundry_environment.api_endpoint
  description = "The org ID of the Cloudfoundry environment instance."
}

output "subaccount_cf_org" {
  value       = local.project_subaccount_cf_org
  description = "The subaccaount CF org."
}

output "region" {
  value       = var.region
  description = "The region of the subaccount"
}
