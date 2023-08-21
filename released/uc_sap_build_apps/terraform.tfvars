#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount   = "youraccount"
region          = "us10"
custom_idp      = "abcde1234.accounts.ondemand.com"

####################################
# Usage within sap canary landscape
####################################
# globalaccount   = "terraformdemocanary"
# region          = "eu12"
# cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"
# custom_idp      = "terraformint.accounts400.ondemand.com"

#################################
# Project specific configuration
#################################
# Account setup
subaccount_name             = "My SAP Build Apps"
# User
emergency_admins            = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsAdmin        = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsDeveloper    = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryAdmin         = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryDeveloper     = ["jane.doe@test.com", "john.doe@test.com"]
