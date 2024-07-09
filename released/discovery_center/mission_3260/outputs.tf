output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "org_id" {
  value       = btp_subaccount_environment_instance.cloudfoundry
  description = "The Cloudfoundry org ID."
}
