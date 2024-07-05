output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
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
