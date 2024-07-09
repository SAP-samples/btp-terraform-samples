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
    value = btp_subaccount.dc_mission.id
} 