#################################
# Provider configuration
#################################

# Enter values from outputs of step1
region                      = "us10"
cf_org_id                   = "affecafe-abcd-ef01-affe-1234cafeaffe"
subaccount_cf_org           = "buildapps12345678901234567890"
api_endpoint                = "https://api.cf.us10.hana.ondemand.com"

# Name of the Cloudfoundry space
subaccount_cf_space         = "development"

# User
cf_space_managers           = ["john.doe@test.com"]
cf_space_developers         = ["john.doe@test.com"]
cf_space_auditors           = ["john.doe@test.com"]
