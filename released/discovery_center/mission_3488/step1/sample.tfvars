# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "yourglobalaccount"
region          = "datacenter"
subaccount_name = "SAP Discovery Center Mission 3488"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------

subaccount_admins         = ["another.user@test.com"]
subaccount_service_admins = ["another.user@test.com"]

cf_org_admins       = ["another.user@test.com"]
cf_space_managers   = ["another.user@test.com", "you@test.com"]
cf_space_developers = ["another.user@test.com", "you@test.com"]

custom_idp = ""

create_tfvars_file_for_next_stage = true

sac_param_first_name = "John"
sac_param_last_name  = "Doe"
sac_param_email      = "john.doe@test.com"
sac_param_host_name  = "johndoetestsac"



