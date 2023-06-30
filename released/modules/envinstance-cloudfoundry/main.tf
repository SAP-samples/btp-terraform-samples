##
# The orchestration user needs administration access to the cloud foundry environment.
##
data "btp_whoami" "orchestrator" {}

resource "null_resource" "cache_orchestrator" {
  triggers = {
    id    = data.btp_whoami.orchestrator.id
    email = data.btp_whoami.orchestrator.email
  }

  lifecycle {
    ignore_changes = all
  }
}

##
# If the user doesn't provide an environment label, we have to look it up. We take the first matching entry.
##
data "btp_subaccount_environments" "all" {
  subaccount_id = var.subaccount_id
}

resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.environment_label) > 0 ? var.environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = var.subaccount_id
  name             = var.instance_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = var.plan_name
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = var.cloudfoundry_org_name
    users = [
      {
        id    = null_resource.cache_orchestrator.triggers.id
        email = null_resource.cache_orchestrator.triggers.email
      }
    ]
  })
}
