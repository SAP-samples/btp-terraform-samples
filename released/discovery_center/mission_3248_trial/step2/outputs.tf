output "abab_trial_service_instance_id" {
  value       = cloudfoundry_service_instance.abap_trial.id
  description = "The ID of the ABAP service instance."
}

output "abab_trial_service_key_id" {
  value       = cloudfoundry_service_credential_binding.abap_trial_service_key.id
  description = "The ID of the ABAP service key."
}