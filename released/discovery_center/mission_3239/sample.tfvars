#################################
# IDP configuration
#################################
custom_idp                     = ""

#################################cd
# Account settings
#################################
globalaccount                  = "<your global account id>"
region                         = "us10"
subaccount_name                = "Mission-3239"
org                            = "team1"
cf_space                       = "dev"
# a valid Cloud Foundry URL - please check which are available for your global account
cf_url                         = "https://api.cf.us10.hana.ondemand.com"

#################################
# User Configuration
#################################
admins               = ["jane.doe@test.com", "john.doe@test.com"]
developers           = ["carl.tester@test.com"]




#################################
# Service Plans
# as an alternativ you could also choose the "free" plans
#################################
build_workzone_service_plan = "standard"
bas_service_plan = "standard-edition"
cicd_service_plan = "default"