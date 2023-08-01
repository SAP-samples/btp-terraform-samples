#################################
# Provider configuration
#################################

# Enter values from outputs of step1
region                      = "us10"
cf_org_id                   = "9bed21f0-fbea-4086-a0cd-0583e65ed2c9"
api_endpoint                = "https://api.cf.us10.hana.ondemand.com"
subaccount_cf_org           = "buildapps1c84b06839160322bf3001f"

# Name of the Cloudfoundry space
subaccount_cf_space         = "development"

# User
emergency_admins            = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_managers           = ["rui.nogueira@sap.com"]
cf_space_developers         = ["rui.nogueira@sap.com"]
cf_space_auditors           = ["rui.nogueira@sap.com"]
