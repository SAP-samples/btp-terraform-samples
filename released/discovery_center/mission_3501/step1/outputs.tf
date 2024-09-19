output "cf_landscape_label" {
  value = btp_subaccount_environment_instance.cloudfoundry.landscape_label
}

output "cf_api_url" {
  value = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
}

output "cf_org_id" {
  value = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

output "subaccount_id" {
  value = data.btp_subaccount.dc_mission.id
}

output "bas_url" {
  value = btp_subaccount_subscription.bas.subscription_url
}
output "hana_cloud_tools_url" {
  value = btp_subaccount_subscription.hana_cloud_tools.subscription_url
}
output "cicd_url" {
  value = btp_subaccount_subscription.cicd.subscription_url
}
output "event_mesh_application_url" {
  value = btp_subaccount_subscription.event_mesh_application.subscription_url
}
output "alm_ts_url" {
  value = btp_subaccount_subscription.alm_ts.subscription_url
}
output "build_workzone_url" {
  value = btp_subaccount_subscription.build_workzone.subscription_url
} 