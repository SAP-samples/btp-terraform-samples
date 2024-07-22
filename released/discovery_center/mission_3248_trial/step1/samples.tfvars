# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
globalaccount = "subdomain of your trial globalaccount"

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt)
# ------------------------------------------------------------------------------------------------------
subaccount_id = "id of your trial subaccount"

# Must be false if CF is enabled and a space with the configured space name already exists
create_cf_space = false
cf_space_name   = "dev"

cf_org_managers = ["anotheruser@test.com"]

# If create_cf_space is true or Clouf Foundry is disabled for your trial subaccount, you must add
# yourself as a space manager and developer. DON'T add yourself if the space exists and you are
# already a space manager or developer of the space.
cf_space_developers = ["anotheruser@test.com", "you@test.com"]
cf_space_managers   = ["anotheruser@test.com", "you@test.com"]

abap_admin_email = "you@your.company.com"

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_next_stage = true
