# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "us10"
subaccount_name = "DC Mission 4033 - Create simple, connected digital experiences with API-based integration 1"
custom_idp      = "<your_idp>.accounts.ondemand.com"

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
subaccount_admins               = ["another.user@test.com"]
subaccount_service_admins       = ["another.user@test.com"]
int_provisioners                = ["another.user@test.com"]
users_buildApps_admins          = ["another.user@test.com"]
users_registry_admins           = ["another.user@test.com"]
users_buildApps_developers      = ["another.user@test.com"]
users_registry_developers       = ["another.user@test.com"]
process_automation_admins       = ["another.user@test.com"]
process_automation_developers   = ["another.user@test.com"]
process_automation_participants = ["another.user@test.com"]

