#################################
# Provider configuration
#################################
# Your global account subdomain
globalaccount   = "terraformdemocanary"
# region
region          = "eu12"
# can be commented out to use the default btp CLI server URL
cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"

#################################
# Project specific configuration
#################################
landscapes       = ["DEV"]
unit             = "Test"
unit_shortname   = "tst"
costcenter       = "1234567890"
custom_idp       = "terraformint.accounts400.ondemand.com"
emergency_admins = ["jane.doe@test.com", "john.doe@test.com"]
