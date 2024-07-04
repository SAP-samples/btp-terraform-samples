# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 4371"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------

subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]
hana_cloud_admins         = ["another.user@test.com", "you@test.com"]

custom_idp = "sap.ids"

# Comment out the next line if you want to provide the password here instead of typing it in the console (not recommended for security reasons)
#hana_system_password = "xxxxxx"
