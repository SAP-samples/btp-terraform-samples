# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 4371"
custom_idp      = "sap.ids"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------

# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!
subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

hana_cloud_admins         = ["another.user@test.com"]
hana_system_password      = "Abc12345"

# Don't add the user, that is executing the TF script to cf_org_admins or cf_org_users!
cf_org_admins       = ["another.user@test.com"]
cf_org_users        = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com", "you@test.com"]
cf_space_developers = ["another.user@test.com", "you@test.com"]
