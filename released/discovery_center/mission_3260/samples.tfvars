# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "youraccount"
region          = "us10"
subaccount_name = "Discovery Center mission 3260 - Process and approve your invoices with SAP Build Process Automation"

service_plan__sap_process_automation = "free"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Don't add the user, that is executing the TF script to subaccount_admins or subaccount_service_admins!
subaccount_admins         = ["jane.doe@test.com", "john.doe@test.com"]
subaccount_service_admins = ["jane.doe@test.com", "john.doe@test.com"]

process_automation_admins       = ["jane.doe@test.com", "john.doe@test.com"]
process_automation_developers   = ["jane.doe@test.com", "john.doe@test.com"]
process_automation_participants = ["jane.doe@test.com", "john.doe@test.com"]

