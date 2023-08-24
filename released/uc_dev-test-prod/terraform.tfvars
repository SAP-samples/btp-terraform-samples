#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount = "ticrossa"
region        = "us10"
custom_idp    = "alv7kqzip.accounts.ondemand.com"

####################################
# Usage within sap canary landscape
####################################
# globalaccount   = "terraformdemocanary"
# region          = "eu12"
# cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"
# custom_idp       = "terraformint.accounts400.ondemand.com"

#################################
# Project specific configuration
#################################
landscapes       = ["DEV", "TST", "PRD"]
unit             = "Test"
unit_shortname   = "tst"
costcenter       = "1234567890"
emergency_admins = ["jane.doe@test.com", "john.doe@test.com"]
