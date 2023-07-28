output "xsuaa_app_id" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.app_id
  description = "The technical ID of the sap-build-apps_standard service instance."
}

output "state" {
  value = btp_subaccount_subscription.sap-build-apps_standard.state
  description = "State ofthe sap-build-apps_standard instance."
}

output "last_modified" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.last_modified
  description = "The last time the resource was updated (ISO 8601 format)."
}

output "url_sap_build_apps" {
  # value       = btp_subaccount_subscription.sap-build-apps_standard.url
  value = "https://" + var.subaccount_domain + "cr1." + car.region + ".apps.build.cloud.sap/"
  description = "The url for the SAP Build Apps destination."
}