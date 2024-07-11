# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "youraccount"
region               = "us10"
subaccount_name      = "SAP Discovery Center Mission 4038"
cf_environment_label = "cf-us10"
cf_space_name        = "dev"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!

subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

int_provisioners            = ["jane.doe@test.com", "john.doe@test.com"]
datasphere_admin_first_name = "First Name"
datasphere_admin_last_name  = "Last Name"
datasphere_admin_email      = "jane.doe@test.com"

service_plan__sap_datasphere        = "standard"
service_plan__sap_integration_suite = "enterprise_agreement"

