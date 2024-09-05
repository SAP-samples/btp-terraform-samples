output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The Global Account subdomain id."
}

output "sap_launchpad_subscription_url" {
  value       = data.btp_subaccount_subscription.sap_launchpad.subscription_url
  description = "SAP Build Work Zone, standard edition subscription URL."
}

output "cicd_app_subscription_url" {
  value       = var.use_optional_resources ? btp_subaccount_subscription.cicd_app[0].subscription_url : null
  description = "Continuous Integration & Delivery subscription URL."
}