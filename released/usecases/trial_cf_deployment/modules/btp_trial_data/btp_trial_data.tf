# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source = "SAP/btp"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Fetch data from SAP BTP Trial Account 
# ------------------------------------------------------------------------------------------------------
locals {
  trial                  = [for acc in data.btp_subaccounts.all.values : acc if acc.name == "trial"][0]
  trial_cloudfoundry_env = [for env in data.btp_subaccount_environment_instances.trial.values : env if env.environment_type == "cloudfoundry"][0]
}

data "btp_subaccounts" "all" {}

data "btp_subaccount_environment_instances" "trial" { subaccount_id = local.trial.id }
