#################################
# Provider configuration
#################################
# user/pw
# user_email                   = "<<user e-mail>>"
# password                     = "<<user password>>"

# idp
custom_idp                     = "<<tenant-id>>.accounts.ondemand.com" /* empty string is default and means SAP ID Service case */

# cli url
# cli_server_url               = "https://cpcli.cf.sap.hana.ondemand.com" /* here canary value; default is for production */

#################################
# Account settings
#################################
# your global account subdomain
globalaccount                  = "your-globalaccount-subdomain"

# subaccount
# subaccount_name              = "<<subaccount-disp-name>>" /* default is 'My SAP Build Apps subaccount' */

# subaccount_id                = "<<subaccount-id>>" /* in case you want to run solution in some specific subaccount */
# region                       = "<<region-id>>" /* default is us-10 (production), use eu12 for canary */

#################################
# Use case specific configuration
#################################
# service plans
# sap_build_apps_service_plan  = "standard" /* free is default */
# build_workzone_service_plan  = "standard" /* free is default */

# User assignments (mandatory)
emergency_admins               = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsAdmin           = ["jane.doe@test.com", "john.doe@test.com"]
users_BuildAppsDeveloper       = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryAdmin            = ["jane.doe@test.com", "john.doe@test.com"]
users_RegistryDeveloper        = ["jane.doe@test.com", "john.doe@test.com"]
