# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
custom_idp = "<<tenant-id>>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
globalaccount   = "<your-global-account-subdomain>"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 4356"

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["another-user@test.com", "you@test.com"]
subaccount_service_admins = ["another-user@test.com", "you@test.com"]

integration_provisioners = ["another-user@test.com", "you@test.com"]
sapappstudio_admins      = ["another-user@test.com", "you@test.com"]
sapappstudio_developers  = ["another-user@test.com", "you@test.com"]

cloud_connector_admins          = ["another-user@test.com", "you@test.com"]
connectivity_destination_admins = ["another-user@test.com", "you@test.com"]

cf_org_admins       = ["another-user@test.com", "you@test.com"]
cf_org_users        = ["another-user@test.com", "you@test.com"]
cf_space_managers   = ["another-user@test.com", "you@test.com"]
cf_space_developers = ["another-user@test.com", "you@test.com"]

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true