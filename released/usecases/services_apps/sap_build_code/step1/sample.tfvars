# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "xxxxxxxx-xxxxxxx-xxxxxxx-xxxxxxxx-xxxxxx"

# The CLI server URL (needs to be set to null if you are using the default CLI server)
cli_server_url = null

# Region for your subaccount
region = "us10"

# Name of your sub account
subaccount_name = "SAP Build Code - quick account setup"

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true

# ------------------------------------------------------------------------------------------------------
# USER ROLES
# ------------------------------------------------------------------------------------------------------
subaccount_admins     = ["another.user@test.com"]
cf_org_admins         = ["another.user@test.com"]
cf_space_manager      = ["another.user@test.com", "you@test.com"]
cf_space_developer    = ["another.user@test.com", "you@test.com"]
build_code_admins     = ["another.user@test.com", "you@test.com"]
build_code_developers = ["another.user@test.com", "you@test.com"]
