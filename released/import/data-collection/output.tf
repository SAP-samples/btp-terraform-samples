# We output the data that we need in order to import the resources in the next step.
output "subaccount_name" {
  description = "The name of the subaccount."
  value       = data.btp_subaccount.my_account.name
}

output "subaccount_region" {
  description = "The region of the subaccount."
  value       = data.btp_subaccount.my_account.region
}

output "subaccount_subdomain" {
  description = "The subdomain of the subaccount."
  value       = data.btp_subaccount.my_account.subdomain
}

output "subaccount_usage" {
  description = "The usage of the subaccount."
  value       = data.btp_subaccount.my_account.usage
}

output "subaccount_labels" {
  description = "The labels of the subaccount."
  value       = data.btp_subaccount.my_account.labels
}

output "entitlement_service_name" {
  description = "The entitlements of the subaccount."
  value       = local.result[var.service_name].service_name
}

output "entitlement_plan_name" {
  description = "The entitlements of the subaccount."
  value       = local.result[var.service_name].plan_name
}
