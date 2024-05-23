##########################################################################
# IAS configuration - 
# Custom IAS must added as "Custom Identity Provider for Platform Users"
# at the global account
##########################################################################
custom_idp                     = "<your custom IAS>"

#################################cd
# Account settings
#################################
globalaccount                  = "<your global account ID"
region                         = "eu10"
subaccount_name                = "devopsdemo"
org                            = "org"
cf_space                       = "dev"
cf_url                         = "https://api.cf.eu10.hana.ondemand.com"
directory_labels = {CostCenter = ["123456"], Department= ["ABCD"]}
subaccount_labels = {Owner = ["Bla Bla"]}

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
