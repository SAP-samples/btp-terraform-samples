# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
custom_idp = "<<tenant-id>>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount = "<your-global-account-subdomain>"
region        = "us10"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
subaccount_admins     = ["another.sap-ids-user@test.com"]
build_code_admins     = ["another.sap-ids-user@test.com", "you@test.com"]
build_code_developers = ["another.sap-ids-user@test.com", "you@test.com"]

cf_org_admins       = ["another.sap-ids-user@test.com"]
cf_space_managers   = ["another.sap-ids-user@test.com", "you@test.com"]
cf_space_developers = ["another.sap-ids-user@test.com", "you@test.com"]

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true
