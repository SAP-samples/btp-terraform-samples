# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "youraccount"
region               = "ap11"
subaccount_name      = "subaccount name"
btp_user = "jane.doe@test.com"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

cf_space_managers   = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_developers = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_auditors   = ["jane.doe@test.com", "john.doe@test.com"]

cf_org_auditors   = ["jane.doe@test.com", "john.doe@test.com"]
cf_org_managers   = ["jane.doe@test.com", "john.doe@test.com"]
cf_org_billing_managers   = ["jane.doe@test.com", "john.doe@test.com"]

#------------------------------------------------------------------------------------------------------
# Entitlements plan update
#------------------------------------------------------------------------------------------------------

bas_plan_name = "standard-edition"
build_workzone_plan_name = "standard"
hana-cloud_plan_name = "hana"
