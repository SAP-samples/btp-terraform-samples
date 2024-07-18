output "subaccount_id" {
  value       = var.subaccount_id
  description = "The ID of the subaccount."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
  description = "The ID of the Cloud Foundry org connected to the subaccount."
}

output "cf_api_url" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}

output "cf_org_managers" {
  value       = var.cf_org_managers
  description = "List of managers for the Cloud Foundry org."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "List of managers for the Cloud Foundry space."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "List of developers for the Cloud Foundry space."
}

output "abap_admin_email" {
  value = var.abap_admin_email
  description = "Email of the ABAP Administrator."
}
