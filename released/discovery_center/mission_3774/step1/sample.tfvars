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

subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

cf_org_admins       = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com", "you@test.com"]
cf_space_developers = ["another.user@test.com", "you@test.com"]

custom_idp       = "sap.ids"
launchpad_admins = ["another.user@test.com", "you@test.com"]