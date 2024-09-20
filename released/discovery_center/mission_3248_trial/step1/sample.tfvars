# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "<your-globalaccount-subdomain>" // <xxxxxxxx>trial-ga

# Region for your trial subaccount
region = "us10"

# Name of your sub account
subaccount_id = "<your trial Subaccount ID>"

# ------------------------------------------------------------------------------------------------------
# Use case specific configurations
# ------------------------------------------------------------------------------------------------------
abap_admin_email = "you@your.company.com"

# This TF script allows you to create a CF space but carefully check conditions
# create_cf_space must be false, if CF is enabled and a space with the configured space name already exists
#
# create_cf_space = true // false (default)

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for the step 2
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true