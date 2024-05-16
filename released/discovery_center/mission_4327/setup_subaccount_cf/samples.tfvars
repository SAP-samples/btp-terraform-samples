# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount        = "<Global Account ID>"
region               = "<BTP Landscape region e.g ap11>"
subaccount_name      = "<Sub Account Name>"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# To add extra users to the subaccount, the user running the script becomes the admin, without inclusion in admins.
subaccount_admins         = ["user1-email", "user2-email"]
# To Create Cloudfoundry Org and add users with specific roles
cf_org_name               = "<NAME FOR CF ORG>"
cf_org_user               = ["user1-email", "user2-email"]
cf_space_manager          = ["user1-email", "user2-email"]
#------------------------------------------------------------------------------------------------------
# Entitlements plan update
#------------------------------------------------------------------------------------------------------
# For production use of Business Application Studio, upgrade the plan from the `free-tier` to the appropriate plan e.g standard-edition
bas_plan_name = "free-tier"
#-------------------------------------------------------------------------------------------------------
#For production use of Build Workzone, upgrade the plan from the `free-tier` to the appropriate plan e.g standard
build_workzone_plan_name = "free-tier"
#--------------------------------------------------------------------------------------------------------
# For production use of HANA, upgrade the plan from the `free-tier` to the appropriate plan e.g hana
hana-cloud_plan_name = "free"
