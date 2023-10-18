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

bas_plan_name = "free-tier"
build_workzone_plan_name = "free-tier"
hana-cloud_plan_name = "free"
