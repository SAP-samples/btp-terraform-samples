# ------------------------------------------------------------------------------------------------------
# Your BTP user credentials (you can also provide them as environment variables)
# ------------------------------------------------------------------------------------------------------
#BTP_USERNAME="your.email@test.com"
# ------------------------------------------------------------------------------------------------------
# Comment out the next line if you want to provide the password here instead of typing it in the console (not recommended for security reasons)
#BTP_PASSWORD="xxxxx"

# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "xxxxxxxx-xxxxxxx-xxxxxxx-xxxxxxxx-xxxxxx"

# The CLI server URL (needs to be set to null if you are using the default CLI server)
cli_server_url = null

# Region for your subaccount
region               = "us10"
cf_environment_label = "cf-us10"

# Name of your sub account
subaccount_name = "GenAI on BTP"

# If set to true, the script will create an app subscription for the AI Launchpad
setup_ai_launchpad = false

# The model that the AI Core service should use
target_ai_core_model = ["gpt-35-turbo", "text-embedding-ada-002"]

# The admin users
admins = ["jane.doe@test.com", "your.email@test.com"]

# Comment out the next line if you want to provide the password here instead of typing it in the console (not recommended for security reasons)
#hana_system_password = "xxxxxx"

