# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 3680"
custom_idp      = "<your_idp>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------

# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!
subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

hana_system_admin    = "another.user@test.com"
hana_system_password = "Abc12345"

# Don't add the user, that is executing the TF script to cf_org_admins or cf_org_users!
cf_org_admins       = ["another.user@test.com"]
cf_org_users        = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com"]
cf_space_developers = ["another.user@test.com"]

# Event Mesh users
event_mesh_admins     = ["another.user@test.com"]
event_mesh_developers = ["another.user@test.com"]

# Build Apps
users_buildApps_admins     = ["another.user@test.com"]
users_registry_admins      = ["another.user@test.com"]
users_buildApps_developers = ["another.user@test.com"]
users_registry_developers  = ["another.user@test.com"]
