# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "yoursubaccount"
region               = "us10"
subaccount_name      = "DC Mission 4033 - Create simple, connected digital experiences with API-based integration 2"
custom_idp           = "youridp.accounts.ondemand.com"

kyma_instance = {
  name            = "my-kyma-environment"
  region          = "us-east-1"
  machine_type    = "mx5.xlarge"
  auto_scaler_min = 3
  auto_scaler_max = 20
  createtimeout   = "1h"
  updatetimeout   = "35m"
  deletetimeout   = "1h"
}

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

conn_dest_admin = ["jane.doe@test.com", "john.doe@test.com"]
int_provisioner = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsAdmin = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryAdmin = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsDeveloper = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryDeveloper = ["jane.doe@test.com", "john.doe@test.com"]
ProcessAutomationAdmin = ["jane.doe@test.com", "john.doe@test.com"]
ProcessAutomationDeveloper = ["jane.doe@test.com", "john.doe@test.com"]
ProcessAutomationParticipant = ["jane.doe@test.com", "john.doe@test.com"]