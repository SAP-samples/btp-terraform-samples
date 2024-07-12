# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "datacenter"
subaccount_name = "subaccount_name"

service_plan__build_workzone = "free"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins
subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

# Don't add the user, that is executing the TF script to cf_org_admins or cf_org_users!
cf_org_admins       = ["another.user@test.com"]
cf_org_users        = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com", "you@test.com"]
cf_space_developers = ["another.user@test.com", "you@test.com"]

custom_idp       = "sap.ids"
launchpad_admins = ["another.user@test.com", "you@test.com"]