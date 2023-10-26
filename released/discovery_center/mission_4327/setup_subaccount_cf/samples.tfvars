# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "<Global Account ID>"
region               = "<BTP Landscape region e.g ap11>"
subaccount_name      = "<Sub Account Name>"
btp_user = "<Your Email Address>"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# To add extra users to the subaccount, the user running the script becomes the admin, without inclusion in admins.
subaccount_admins         = ["user1-email", "user2-email"]
subaccount_service_admins = ["user1-email", "user2-email"]

cf_space_managers   = ["user1-email", "user2-email"]
cf_space_developers = ["user1-email", "user2-email"]
cf_space_auditors   = ["user1-email", "user2-email"]

cf_org_auditors   = ["user1-email", "user2-email"]
cf_org_managers   = ["user1-email", "user2-email"]
cf_org_billing_managers   = ["user1-email", "user2-email"]

#------------------------------------------------------------------------------------------------------
# Entitlements plan update
#------------------------------------------------------------------------------------------------------
# For production use of Business Application Studio, upgrade the plan from the `free-tier` to the appropriate plan e.g standard-edition
bas_plan_name = "<free-tier>"
#-------------------------------------------------------------------------------------------------------
#For production use of Build Workzone, upgrade the plan from the `free-tier` to the appropriate plan e.g standard
build_workzone_plan_name = "free-tier"
#--------------------------------------------------------------------------------------------------------
# For production use of HANA, upgrade the plan from the `free-tier` to the appropriate plan e.g hana
hana-cloud_plan_name = "free"
