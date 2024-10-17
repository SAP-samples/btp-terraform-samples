# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "Myglobalaccount"
# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Subaccount configuration
region          = "us10"
subaccount_name = "<name for subaccount>"
# To add extra users to the subaccount, the user running the script becomes the admin, without inclusion in admins.
subaccount_admins = ["joe.do@sap.com", "jane.do@sap.com"]
#------------------------------------------------------------------------------------------------------
# Cloud Foundry
#------------------------------------------------------------------------------------------------------
# Choose a unique organization name e.g., based on the global account subdomain and subaccount name
cf_org_name = "<unique org name>"
