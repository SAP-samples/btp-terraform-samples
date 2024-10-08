# ------------------------------------------------------------------------------------------------------
# account
# ------------------------------------------------------------------------------------------------------
output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "custom_idp" {
  value       = var.custom_idp
  description = "The custom identity provider."
}

# ------------------------------------------------------------------------------------------------------
# service related params
# ------------------------------------------------------------------------------------------------------
output "service_plan__sac" {
  value       = var.service_plan__sac
  description = "Plan for the service instance of SAC."
}

output "sac_admin_email" {
  value       = var.sac_admin_email
  description = "SAC Admin Email"
}

output "sac_admin_first_name" {
  value       = var.sac_admin_first_name
  description = "SAC Admin First Name"
}

output "sac_admin_last_name" {
  value       = var.sac_admin_last_name
  description = "SAC Admin Last Name"
}

output "sac_admin_host_name" {
  value       = var.sac_admin_host_name
  description = "SAC Admin Host Name"
}

output "sac_number_of_business_intelligence_licenses" {
  value       = var.sac_number_of_business_intelligence_licenses
  description = "Number of business intelligence licenses"
}


output "sac_number_of_professional_licenses" {
  value       = var.sac_number_of_professional_licenses
  description = "Number of business professional licenses"
}

output "sac_number_of_business_standard_licenses" {
  value       = var.sac_number_of_business_standard_licenses
  description = "Number of business standard licenses"
}

output "enable_service_setup__sac" {
  value       = var.enable_service_setup__sac
  description = "If true setup of service 'SAP Analytics Cloud' with technical name 'analytics-planning-osb' is enabled"
}

# ------------------------------------------------------------------------------------------------------
# environments
# ------------------------------------------------------------------------------------------------------
output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "The Cloudfoundry landscape label."
}

output "cf_api_url" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "The Cloudfoundry API Url."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
  description = "The Cloudfoundry org id."
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]
  description = "The Cloudfoundry org name."
}

output "cf_space_name" {
  value       = var.cf_space_name
  description = "The name of the Cloud Foundry space."
}

output "cf_org_managers" {
  value       = var.cf_org_managers
  description = "List of users to set as Cloudfoundry org administrators."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "List of users to set as Cloudfoundry space developers."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "List of users to set as Cloudfoundry space managers."
}