# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "us10"
subaccount_name = "SAP Discovery Center Mission 4371"
cf_org_name     = "cf-environment"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------

subaccount_admins         = ["john.doe@sap.com"]
subaccount_service_admins = ["john.doe@sap.com"]
hana_cloud_admins         = ["john.doe@sap.com"]

custom_idp = "sap.ids"

hana_system_password = "Abc12345"

cf_space_developers = ["john.doe@sap.com"]
cf_space_managers   = ["john.doe@sap.com"]
cf_org_admins       = ["john.doe@sap.com"]
cf_org_users        = ["john.doe@sap.com"]

event_mesh_admins     = ["john.doe@sap.com"]
event_mesh_developers = ["john.doe@sap.com"]
