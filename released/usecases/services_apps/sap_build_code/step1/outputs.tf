output "globalaccount" {
  value       = var.globalaccount
  description = "The Global Account subdomain"
}

output "cli_server_url" {
  value       = var.cli_server_url
  description = "The Global Account subdomain"
}

output "subaccount_id" {
  value       = btp_subaccount.build_code.id
  description = "The Global Account subdomain"
}

output "cf_api_endpoint" {
  value       = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]}"
  description = "The Global Account subdomain"
}

output "cf_org_id" {
  value       = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]}"
  description = "The Global Account subdomain"
}

output "cf_org_name" {
  value       = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]}"
  description = "The Global Account subdomain"
}

output "identity_provider" {
  value       = var.identity_provider
  description = "The Global Account subdomain"
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "The Global Account subdomain"
}
output "cf_space_developer" {
  value       = var.cf_space_developer
  description = "The Global Account subdomain"
}
output "cf_space_manager" {
  value       = var.cf_space_manager
  description = "The Global Account subdomain"
}
