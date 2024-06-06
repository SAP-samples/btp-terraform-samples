output "cf_api_endpoint" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]
  description = "The Cloudfoundry API endpoint."
}

output "cf_org_id" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]
  description = "The Cloudfoundry ORG id."
}

output "cf_org_name" {
  value       = jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]
  description = "The Cloudfoundry ORG name."

}

output "admins" {
  value       = var.admins
  description = "The admins of the Cloudfoundry ORG."
}

output "identity_provider" {
  value       = var.identity_provider
  description = "The identity provider for the users"
}
