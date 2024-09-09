/*
output "globalaccount" {
  value       = var.globalaccount
  description = "The Global Account subdomain."
}

output "cli_server_url" {
  value       = var.cli_server_url
  description = "The BTP CLI server URL."
}
*/

output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "build_code_subscription_url" {
  value       = btp_subaccount_subscription.build_code.subscription_url
  description = "SAP Build Code subscription URL."
}

output "custom_idp" {
  value       = var.custom_idp
  description = "The custom identity provider."
}

output "cf_api_url" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "The Cloudfoundry API URL."
}

output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "The Cloudfoundry landscape label."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
  description = "The Cloudfoundry org id."
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]
  description = "The Cloudfoundry org name."
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "List of users to set as Cloudfoundry org administrators."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "List of users to set as Cloudfoundry space developers."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "List of users to set as Cloudfoundry space managers."
}
