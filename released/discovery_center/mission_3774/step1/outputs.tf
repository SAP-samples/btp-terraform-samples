output "subaccount_id" {
  value       = btp_subaccount.dc_mission.id
  description = "The ID of the subaccount."
}

output "cf_api_url" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "The Cloudfoundry API endpoint."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]
  description = "The Cloudfoundry org id."
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]
  description = "The Cloudfoundry org name."
}

output "cf_landscape_label" {
  value       = btp_subaccount_environment_instance.cloudfoundry.landscape_label
  description = "Landscape label of the Cloud Foundry environment."
}

output "cf_org_admins" {
  value       = var.cf_org_admins
  description = "The Cloudfoundry org admins."
}

output "cf_org_users" {
  value       = var.cf_org_users
  description = "The Cloudfoundry org users."
}

output "cf_space_developers" {
  value       = var.cf_space_developers
  description = "The Cloudfoundry space developers."
}

output "cf_space_managers" {
  value       = var.cf_space_managers
  description = "The Cloudfoundry space managers."

}

output "cf_space_name" {
  value       = var.cf_space_name
  description = "The Cloudfoundry space name."
}

output "origin" {
  value       = var.origin
  description = "The origin of the identity provider."
}
