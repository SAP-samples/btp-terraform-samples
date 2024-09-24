output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "cf_api_url" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "The Cloudfoundry API endpoint."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
  description = "The Cloudfoundry org id."
}

output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "Landscape label of the Cloud Foundry environment."
}

output "event_mesh_url" {
  value       = btp_subaccount_subscription.event_mesh_application.subscription_url
  description = "Event Mesh URL"
}

output "hana_tools_url" {
  value       = btp_subaccount_subscription.hana_cloud_tools.subscription_url
  description = "HANA Tools URL"
}
output "build_apps_url" {
  value       = btp_subaccount_subscription.sap-build-apps_standard.subscription_url
  description = "SAP Build Apps URL"
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]
  description = "The Cloudfoundry org name."
}
