output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "cf_org_name" {
  value       = local.subaccount_cf_org
  description = "The name of the Cloud Foundry org connected to the subaccount."
}

output "cf_org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry.platform_id
  description = "The ID of the Cloud Foundry org connected to the subaccount."
}

output "cf_api_url" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}

output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "Landscape label of the Cloud Foundry environment."
}

output "cf_space_name" {
  value       = var.cf_space_name
  description = "The name of the Cloud Foundry space."
}

output "origin" {
  value       = var.origin
  description = "The identity provider for the UAA user."
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "List of Cloud Foundry org admins."
}

output "cf_org_billing_managers" {
  value       = var.cf_org_billing_managers
  description = "List of Cloud Foundry org billing managers."
}

output "cf_org_auditors" {
  value       = var.cf_org_auditors
  description = "List of Cloud Foundry org auditors."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "List of managers for the Cloud Foundry space."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "List of developers for the Cloud Foundry space."
}

output "cf_space_auditors" {
  value       = var.cf_space_auditors
  description = "The list of Cloud Foundry space auditors."
}

output "service_plan__sac" {
  value       = var.service_plan__sac
  description = "Plan for the service instance of SAC."
}

output "sac_param_first_name" {
  value       = var.sac_param_first_name
  description = "First name of the SAC responsible"
}

output "sac_param_last_name" {
  value       = var.sac_param_last_name
  description = "Last name of the SAC responsible"
}

output "sac_param_email" {
  value       = var.sac_param_email
  description = "Email of the SAC responsible"
}

output "sac_param_host_name" {
  value       = var.sac_param_host_name
  description = "Host name of the SAC"
}

output "sac_param_number_of_business_intelligence_licenses" {
  value       = var.sac_param_number_of_business_intelligence_licenses
  description = "Number of business intelligence licenses"
}


output "sac_param_number_of_professional_licenses" {
  value       = var.sac_param_number_of_professional_licenses
  description = "Number of business professional licenses"
}

output "sac_param_number_of_business_standard_licenses" {
  value       = var.sac_param_number_of_business_standard_licenses
  description = "Number of business standard licenses"
}
