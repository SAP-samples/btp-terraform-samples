output "subaccount_id" {
  value       = var.subaccount_id
  description = "The ID of the subaccount."
}

output "cf_org_id" {
  value       = local.cf_environment_instance.platform_id
  description = "The ID of the Cloud Foundry org connected to the subaccount."
}

output "cf_api_url" {
  value       = lookup(jsondecode(local.cf_environment_instance.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}

output "cf_landscape_label" {
  value       = local.cf_environment_instance.landscape_label
  description = "Landscape label of the Cloud Foundry environment."
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

output "cf_space_name" {
  value       = var.cf_space_name
  description = "The name of the CF space to use."
}

output "create_cf_space" {
  value       = local.create_cf_space
  description = "Determines whether a new CF space should be created. Must be true if no space with the name cf_space_name exists for the Org, yet, and false otherwise."
}

output "abap_admin_email" {
  value       = var.abap_admin_email
  description = "Email of the ABAP Administrator."
}
