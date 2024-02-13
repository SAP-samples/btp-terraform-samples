# ------------------------------------------------------------------------------------------------------
# Your BTP user credentials (you can also provide them as environment variables)
# ------------------------------------------------------------------------------------------------------
BTP_USERNAME="your.email@test.com"
# ------------------------------------------------------------------------------------------------------
# Comment out the next line if you want to provide the password here instead of typing it in the console (not recommended for security reasons)
BTP_PASSWORD="xxxxx"

# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount = "xxxxxxxx-xxxxxxx-xxxxxxx-xxxxxxxx-xxxxxx"

# Region for your subaccount
region        = "us10"

# Name of your sub account
subaccount_name = "GenAI on BTP"

ai_core_plan_name = "extended"

admins  = ["jane.doe@test.com", "your.email@test.com"]

# The model that the AI Core service should use
target_ai_core_model = ["gpt-35-turbo", "text-embedding-ada-002"]

# Comment out the next line if you want to provide the password here instead of typing it in the console (not recommended for security reasons)
#hana_system_password = "xxxxxx"

cli_server_url = null