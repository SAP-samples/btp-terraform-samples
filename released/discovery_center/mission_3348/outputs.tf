output "subaccount_id" {
  value       = data.btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "sac_instance_dashboard_url" {
  value = btp_subaccount_service_instance.sac.dashboard_url
}