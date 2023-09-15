output "xsuaa_app_id" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.app_id
  description = "The technical ID of the sap-build-apps_standard service instance."
}

output "state" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.state
  description = "State ofthe sap-build-apps_standard instance."
}

output "last_modified" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.last_modified
  description = "The last time the resource was updated (ISO 8601 format)."
}

output "sap_build_apps_subscription_url" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.subscription_url
  description = "All details of SAP Build Apps"
}
