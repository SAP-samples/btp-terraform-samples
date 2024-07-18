########################################################################
# Account settings
########################################################################
globalaccount   = "<your global account id>"
region          = "us10"
subaccount_name = "learningjourney"

# Set the subaccount_id ro run the script in an existing subaccount, 
# keep it empty to create a new one, for that you need the global account administration role
subaccount_id = ""

#####################################################################################
# Subaccount administrators - don't add your own user here, your ID is added automatically
#####################################################################################
subaccount_admins = ["jane.doe@test.com", "john.doe@test.com"]


#####################################################################################
# Service administrators and developers - add your ID here
#####################################################################################
service_admins = ["jane.doe@test.com", "john.doe@test.com"]
developers     = ["carl.dev@test.com"]

#####################################################################################
# Service plans - for testing the services you can set "free" as value, the free service plan 
# is only supported for SAP BTP accounts  with the CPEA, BTPEA or Pay-as-you-go commercial model
#####################################################################################
build_workzone_service_plan = "standard"
bas_service_plan            = "standard-edition"
cicd_service_plan           = "default"
