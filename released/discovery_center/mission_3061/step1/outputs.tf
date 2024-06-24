output "subaccount_id" {
  value       = btp_subaccount.abap_subaccount.id
  description = "The ID of the subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.abap_subaccount.id
  description = "The name of the subaccount."
}

output "cloudfoundry_org_name" {
  value       = local.subaccount_cf_org
  description = "The name of the Cloud Foundry org connected to the subaccount."
}

output "cloudfoundry_org_id" {
  value       = btp_subaccount_environment_instance.cf_abap.platform_id
  description = "The ID of the Cloud Foundry org connected to the subaccount."
}

output "cloudfoundry_api_url" {
  value       = lookup(jsondecode(btp_subaccount_environment_instance.cf_abap.labels), "API Endpoint", "not found")
  description = "API endpoint of the Cloud Foundry environment."
}

output "abap_sid" {
  value       = var.abap_sid
  description = "SID of the ABAP system."
}