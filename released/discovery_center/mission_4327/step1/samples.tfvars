# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "myglobalaccount"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Subaccount configuration
region          = "us10"
subaccount_name = "DCM Goldenpath"
# To add extra users to the subaccount, the user running the script becomes the admin, without inclusion in admins.
subaccount_admins = ["joe.do@sap.com", "jane.do@sap.com"]
#------------------------------------------------------------------------------------------------------
# Entitlements plan update
#------------------------------------------------------------------------------------------------------
# For production use of Business Application Studio, upgrade the plan from the `free-tier` to the appropriate plan e.g standard-edition
service_plan__bas = "standard-edition"
#-------------------------------------------------------------------------------------------------------
# For production use of Build Workzone, upgrade the plan from the `free-tier` to the appropriate plan e.g standard
service_plan__build_workzone = "standard"
#--------------------------------------------------------------------------------------------------------
# For production use of HANA, upgrade the plan from the `free-tier` to the appropriate plan e.g hana
service_plan__hana_cloud = "hana"
#------------------------------------------------------------------------------------------------------
# Cloud Foundry
#------------------------------------------------------------------------------------------------------
# Choose a unique organization name e.g., based on the global account subdomain and subaccount name
cf_org_name = "<unique_org_name>"
# Additional Cloud Foundry users
cf_space_developers = ["john.doe@sap.com"]
cf_space_managers   = ["john.doe@sap.com"]
cf_org_admins       = ["john.doe@sap.com"]
cf_org_users        = ["john.doe@sap.com"]
