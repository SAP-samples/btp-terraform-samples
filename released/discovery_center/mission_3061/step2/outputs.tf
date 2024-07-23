output "abab_service_instance_id" {
  value       = cloudfoundry_service_instance.abap_si.id
  description = "The ID of the ABAP service instance."
}

output "abap_dashboard_url" {
  value       = cloudfoundry_service_instance.abap_si.dashboard_url
  description = "The URL of the ABAP service instance dashboard."
}

output "abab_adt_key_id" {
  value       = cloudfoundry_service_credential_binding.abap_adt_key.id
  description = "The ID of the ABAP service key for ADT."
}

output "abab_ips_key_id" {
  value       = cloudfoundry_service_credential_binding.abap_ips_key.id
  description = "The ID of the ABAP service key for COMM Arrangement."
}
