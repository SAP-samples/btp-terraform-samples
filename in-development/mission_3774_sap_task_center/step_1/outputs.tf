output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "cf_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the project subaccount."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "The ID of the Cloud Foundry environment."
}

output "cf_api_endpoint" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "API endpoint of the Cloud Foundry environment."
}

output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
  description = "The landscape label of the Cloud Foundry environment."
}

output "cf_space_name" {
value       = cloudfoundry_space.space.name
description = "The name of the Cloud Foundry space."
}