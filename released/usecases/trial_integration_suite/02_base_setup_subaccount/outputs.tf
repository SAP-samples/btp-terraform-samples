output "subaccount_id" {
  description = "The ID of the subaccount"
  value       = btp_subaccount.project_subaccount.id
}

output "cf_space_id" {
  description = "The ID of the Cloud Foundry space"
  value       = cloudfoundry_space.project_space.id
}
