# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "youraccount"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 3945"
custom_idp      = "<your-idp>.accounts.ondemand.com"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!

subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

sac_admin_first_name = "First Name"
sac_admin_last_name  = "Last Name"
sac_admin_email      = "jane.doe@test.com"

service_plan__sap_analytics_cloud = "production"

