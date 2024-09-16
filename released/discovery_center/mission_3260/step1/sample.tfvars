# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
custom_idp = "<<tenant-id>>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount = "<your-global-account-subdomain>"
region        = "us10"

subaccount_name = "Your Mission 3260 Subaccount Name"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["another.sap-ids-user@test.com", "you@test.com"]
subaccount_service_admins = ["another.sap-ids-user@test.com", "you@test.com"]

process_automation_admins       = ["another.sap-ids-user@test.com", "you@test.com"]
process_automation_developers   = ["another.sap-ids-user@test.com", "you@test.com"]
process_automation_participants = ["another.sap-ids-user@test.com", "you@test.com"]

cf_org_admins       = ["another.sap-ids-user@test.com", "you@test.com"]
cf_org_users        = ["another.sap-ids-user@test.com", "you@test.com"]
cf_space_managers   = ["another.sap-ids-user@test.com", "you@test.com"]
cf_space_developers = ["another.sap-ids-user@test.com", "you@test.com"]

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true