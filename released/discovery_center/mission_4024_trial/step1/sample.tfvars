# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "<your-globalaccount-subdomain>" // <xxxxxxxx>trial-ga

# Region for your trial subaccount
region = "us10"

subaccount_id = "<your trial Subaccount ID>"

# ------------------------------------------------------------------------------------------------------
# Use case specific role assignments
# ------------------------------------------------------------------------------------------------------
subaccount_admins             = ["jane.doe@test.com"]
launchpad_admins              = ["jane.doe@test.com"]
build_apps_admins             = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_developers         = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_registry_admin     = ["jane.doe@test.com", "john.doe@test.com"]
build_apps_registry_developer = ["jane.doe@test.com", "john.doe@test.com"]

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true