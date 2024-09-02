# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
custom_idp = "<<tenant-id>>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount   = "your-globalaccount-subdomain"
region          = "us10"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
subaccount_admins               = ["jane.doe@test.com"]
launchpad_admins                = ["jane.doe@test.com"]
build_apps_admins               = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_developers           = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_registry_admin       = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_registry_developer   = ["jane.doe@test.com", "john.doe@test.com"]

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true