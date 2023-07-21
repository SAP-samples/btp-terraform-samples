#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount   = "terraformdemocanary"
# region
region          = "us10"

# Usage within sap canary landscape
# region          = "eu12"
# cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"

#################################
# Project specific configuration
#################################
landscapes       = ["DEV"]
unit             = "Test"
unit_shortname   = "tst"
costcenter       = "1234567890"
custom_idp       = "terraformint.accounts400.ondemand.com"
emergency_admins = ["jane.doe@test.com", "john.doe@test.com"]
