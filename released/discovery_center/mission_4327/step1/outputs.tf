output "subaccount_id" {
  value = btp_subaccount.project.id
}

output "cf_landscape_label" {
  value = terraform_data.cf_landscape_label.output
}

output "cf_org_id" {
  value = btp_subaccount_environment_instance.cloudfoundry.platform_id
}

output "cf_api_url" {
  value = lookup(jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels), "API Endpoint", "not found")
}
