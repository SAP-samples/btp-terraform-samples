output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}

output "cloudfoundry_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]
  description = "The ID of the cloudfoundry org connected to the project account."
}

output "cloudfoundry_api_endpoint" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]
  description = "The Global Account subdomain"
}

output "cloudfoundry_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]
  description = "The Global Account subdomain"
}