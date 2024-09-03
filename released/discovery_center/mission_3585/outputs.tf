output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The Global Account subdomain id."
}

output "sapappstudio_subscription_url" {
  value       = btp_subaccount_subscription.sapappstudio.subscription_url
  description = "SAP Business Application Studio subscription URL."
}

output "sap_launchpad_subscription_url" {
  value       = var.use_optional_resources ? btp_subaccount_subscription.sap_launchpad[0].subscription_url : null
  description = "SAP Build Work Zone, standard edition subscription URL."
}

output "cicd_service_id" {
  value = var.use_optional_resources ? btp_subaccount_service_instance.cicd_service[0].id : null
}

output "cicd_app_subscription_url" {
  value       = var.use_optional_resources ? btp_subaccount_subscription.cicd_app[0].subscription_url : null
  description = "Continuous Integration & Delivery subscription URL."
}