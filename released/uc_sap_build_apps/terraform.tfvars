#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount   = "ticrossa"
region          = "us10"
custom_idp      = "abcdefghijk.accounts.ondemand.com"

####################################
# Usage within sap canary landscape
####################################
#globalaccount   = "terraformdemocanary"
#region          = "eu12"
#cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"
#custom_idp      = "terraformint.accounts400.ondemand.com"

#################################
# Project specific configuration
#################################
# Account setup
subaccount_name             = "My SAP Build Apps 2"
# Name of the Cloudfoundry space
subaccount_cf_space         = "development"
# User
emergency_admins            = ["jane.doe@test.com", "john.doe@test.com"]

cf_space_managers           = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_developers         = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_auditors           = ["jane.doe@test.com", "john.doe@test.com"]

users_BuildAppsAdmin        = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsDeveloper    = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryAdmin         = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryDeveloper     = ["jane.doe@test.com", "john.doe@test.com"]
