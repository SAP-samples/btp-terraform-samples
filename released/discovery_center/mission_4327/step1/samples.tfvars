# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "terraformintprod"
region          = "eu10"
subaccount_name = "dcmqas"
cf_landscape_label = "cf-eu10"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# To add extra users to the subaccount, the user running the script becomes the admin, without inclusion in admins.
subaccount_admins = ["joe.do@sap.com", "jane.do@sap.com"]
# To Create Cloudfoundry Org and add users with specific roles
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
