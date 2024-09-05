# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount = "<your-global-account-subdomain>"
region        = "us10"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!
subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

process_automation_admins       = ["jane.doe@test.com", "john.doe@test.com"]
process_automation_developers   = ["jane.doe@test.com", "john.doe@test.com"]
process_automation_participants = ["jane.doe@test.com", "john.doe@test.com"]