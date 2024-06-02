#################################cd
# Account settings
#################################
globalaccount                  = "<your global account ID"
region                         = "eu10"
subaccount_name                = "devopsdemo"
org                            = "org"
cf_space                       = "dev"
# a valid Cloud Foundry URL - please check which are available for your global account
cf_url                         = "https://api.cf.eu10.hana.ondemand.com"
directory_labels = {CostCenter = ["123456"], Department= ["ABCD"]}
subaccount_labels = {Owner = ["Bla Bla"]}

##############################################
# IAS configuration for application users 
# if not set the default would be taken
##############################################
#custom_idp = "your IAS for application users"

######################################################################
# IAS configuration - Set the origin of the custom platform user trust.
# If not set the sap.ids would be taken
#####################################################################
#origin = "the origin for the IAS for platform users"


############################################################
# User configuration - the users must exit in the custom IAS
############################################################
admins               = ["your.admin@mail.com"]
developers           = ["developer@mail.com"]

#################################
# SAP HANA Cloud configuration
#################################

hana_system_password = "<password>"
hana_db_name = "HANADB"

#################################
# Service Plans
# as an alternativ you could also choose the "free" plans
#################################
cicd_service_plan = "default"
