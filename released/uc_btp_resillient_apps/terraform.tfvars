#################################
# Project specific configuration
#################################
# Your global account subdomain
globalaccount        = "ticrossa"
region               = "us10"
subaccount_name      = "UC - Build resilient BTP Apps 1"
cf_environment_label = "cf-us10"
cf_space_name        = "development"

# Usage within canary landscape
#globalaccount   = "terraformdemocanary"
#region          = "eu12"
#cli_server_url  = "https://cpcli.cf.sap.hana.ondemand.com"

subaccount_admins         = ["rui.nogueira@sap.com"]
subaccount_service_admins = ["rui.nogueira@sap.com"]

cf_space_managers   = ["rui.nogueira@sap.com"]
cf_space_developers = ["rui.nogueira@sap.com"]
cf_space_auditors   = ["rui.nogueira@sap.com"]
