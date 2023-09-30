output "id" {
  description = "The ID of the trial account"
  value       = local.trial.id
}

output "cloudfoundry" {
  description = "The cloudfoundry environment which is by default created for your trialaccount"
  value = {
    api_endpoint = lookup(jsondecode(local.trial_cloudfoundry_env.labels), "API Endpoint")
    org_id       = lookup(jsondecode(local.trial_cloudfoundry_env.labels), "Org ID")
    org_name     = lookup(jsondecode(local.trial_cloudfoundry_env.labels), "Org Name")
    region       = replace(local.trial_cloudfoundry_env.landscape_label, "/cf-/", "")
  }
}
