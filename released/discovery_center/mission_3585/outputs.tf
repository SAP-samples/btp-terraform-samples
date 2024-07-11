output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The Global Account subdomain id."
}

output "cicd_app_subscription_url" {
  value       = btp_subaccount_subscription.cicd_app.subscription_url
  description = "Continuous Integration & Delivery subscription URL."
}

output "sapappstudio_subscription_url" {
  value       = btp_subaccount_subscription.sapappstudio.subscription_url
  description = "SAP Business Application Studio subscription URL."
}

output "sap_launchpad_subscription_url" {
  value       = btp_subaccount_subscription.sap_launchpad.subscription_url
  description = "SAP Build Work Zone, standard edition subscription URL."
}
