# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "ticoo"
region          = "us10"
subaccount_name = "DC Mission 4033 - Create simple, connected digital experiences with API-based integration 1"
custom_idp      = "ag6010bvf.accounts.ondemand.com"

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
subaccount_admins            = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
subaccount_service_admins = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
emergency_admins = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
conn_dest_admin              = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
int_provisioner              = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
users_BuildAppsAdmin         = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
users_RegistryAdmin          = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
users_BuildAppsDeveloper     = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
users_RegistryDeveloper      = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
ProcessAutomationAdmin       = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
ProcessAutomationDeveloper   = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
ProcessAutomationParticipant = ["m.palavalli@sap.com", "m.palavalli1@sap.com"]
