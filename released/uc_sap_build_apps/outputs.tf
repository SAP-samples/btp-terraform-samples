output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}

output "sap_build_apps_subscription_url" {
  value       = module.sap-build-apps_standard.sap_build_apps_subscription_url
  description = "Subscription URL of SAP Build Apps"
}