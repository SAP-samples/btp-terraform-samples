#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount   = "ticrossa"
region          = "us10"
custom_idp      = "alv7kqzip.accounts.ondemand.com"

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
subaccount_name             = "My SAP Build Apps2"
# User
emergency_admins            = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsAdmin        = ["rui.nogueira@sap.com"]
users_BuildAppsDeveloper    = ["rui.nogueira@sap.com"]
users_RegistryAdmin         = ["rui.nogueira@sap.com"]
users_RegistryDeveloper     = ["rui.nogueira@sap.com"]
