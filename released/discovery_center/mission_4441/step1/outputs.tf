output "globalaccount" {
  value       = var.globalaccount
  description = "The Global Account subdomain."
}

output "cli_server_url" {
  value       = var.cli_server_url
  description = "The BTP CLI server URL."
}

output "subaccount_id" {
  value       = btp_subaccount.build_code.id
  description = "The Global Account subdomain id."
}

output "cf_api_endpoint" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]
  description = "The Cloudfoundry API endpoint."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]
  description = "The Cloudfoundry org id."
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]
  description = "The Cloudfoundry org name."
}

output "custom_idp" {
  value       = var.custom_idp
  description = "The custom identity provider."
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "List of users to set as Cloudfoundry org administrators."
}

output "cf_space_developer" {
  value       = var.cf_space_developer
  description = "List of users to set as Cloudfoundry space developers."
}

output "cf_space_manager" {
  value       = var.cf_space_manager
  description = "List of users to set as Cloudfoundry space managers."
}
