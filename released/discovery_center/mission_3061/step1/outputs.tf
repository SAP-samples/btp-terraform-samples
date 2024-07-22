output "subaccount_id" {
  value       = btp_subaccount.abap_subaccount.id
  description = "The ID of the subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.abap_subaccount.id
  description = "The name of the subaccount."
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

output "abap_sid" {
  value       = var.abap_sid
  description = "SID of the ABAP system."
}

output "abap_compute_unit_quota" {
  value       = var.abap_compute_unit_quota
  description = "The amount of ABAP compute units to be assigned to the subaccount."
}

output "hana_compute_unit_quota" {
  value       = var.hana_compute_unit_quota
  description = "The amount of ABAP compute units to be assigned to the subaccount."
}

output "origin" {
  value       = var.origin
  description = "The identity provider for the UAA user."
}

output "cf_org_managers" {
  value       = var.cf_org_managers
  description = "List of Cloud Foundry org managers."
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

output "service_plan__abap" {
  value       = var.service_plan__abap
  description = "Plan for the service instance of ABAP."
}

output "abap_admin_email" {
  value       = local.abap_admin_email
  description = "Email of the ABAP Administrator."
}

output "abap_is_development_allowed" {
  value       = var.abap_is_development_allowed
  description = "Flag to define if development on the ABAP system is allowed."
}
