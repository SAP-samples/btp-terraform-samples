# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "xxxxxxxx-xxxxxxx-xxxxxxx-xxxxxxxx-xxxxxx"

# The CLI server URL (needs to be set to null if you are using the default CLI server)
cli_server_url = null

# Region for your subaccount
region = "us20"

# Name of your sub account
subaccount_name = "SAP Discovery Center Mission 3808"

# custom_idp = "sap.custom"

# ------------------------------------------------------------------------------------------------------
# USER ROLES
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

cf_org_admins       = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com", "you@test.com"]
cf_space_developers = ["another.user@test.com", "you@test.com"]

launchpad_admins = ["another.user@test.com", "you@test.com"]