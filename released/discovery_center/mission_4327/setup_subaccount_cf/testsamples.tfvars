# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "terraformintprod"
region               = "eu10"
subaccount_name      = "dcmtest"
subaccount_admins    = ["jane.doe@test.com", "john.doe@test.com"]
cf_org_user          = ["jane.doe@test.com", "john.doe@test.com"]
cf_space_manager     = ["jane.doe@test.com", "john.doe@test.com"]

#------------------------------------------------------------------------------------------------------
# Entitlements plan update
#------------------------------------------------------------------------------------------------------
# For production use of Business Application Studio, upgrade the plan from the `free-tier` to the appropriate plan e.g standard-edition
bas_plan_name = "standard-edition"
#-------------------------------------------------------------------------------------------------------
#For production use of Build Workzone, upgrade the plan from the `free-tier` to the appropriate plan e.g standard
build_workzone_plan_name = "standard"
#--------------------------------------------------------------------------------------------------------
# For production use of HANA, upgrade the plan from the `free-tier` to the appropriate plan e.g hana
hana-cloud_plan_name = "hana"
