# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
custom_idp = "<<tenant-id>>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount   = "<your-global-account-subdomain>"
region          = "eu10"
subaccount_name = "SAP Discovery Center Mission 3252"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["another-user@test.com", "you@test.com"]
subaccount_service_admins = ["another-user@test.com", "you@test.com"]

# Kyma instance parameters. When set to null, the name will be set to the subaccount subdomain and the
# first available cluster region for the subaccount will be selected.
kyma_instance_parameters = {
  name            = "my-kyma-environment"
  region          = "eu-central-1"
  machine_type    = "mx5.xlarge"
  auto_scaler_min = 3
  auto_scaler_max = 20
}