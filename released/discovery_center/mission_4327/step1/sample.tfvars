# ------------------------------------------------------------------------------------------------------
# Account settings
# ------------------------------------------------------------------------------------------------------
custom_idp    = "<<tenant-id>>.accounts.ondemand.com"
globalaccount = "<<your-global-account-subdomain>>"

subaccount_admins         = ["you@acme.com", "other.user@acme.com"]
subaccount_service_admins = ["you@acme.com", "other.user@acme.com"]

# ------------------------------------------------------------------------------------------------------
# Use case specific configuration
# ------------------------------------------------------------------------------------------------------
cf_org_managers     = ["you@acme.com", "other.user@acme.com"]
cf_org_users        = ["you@acme.com", "other.user@acme.com"]
cf_space_managers   = ["you@acme.com", "other.user@acme.com"]
cf_space_developers = ["you@acme.com", "other.user@acme.com"]

launchpad_admins  = ["you@acme.com", "other.user@acme.com"]
hana_cloud_admins = ["you@acme.com", "other.user@acme.com"]


# ------------------------------------------------------------------------------------------------------
# additional configuration (dev & testing)
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true

# (optional) test enable/disable service setups
#enable_service_setup__hana_cloud = false
#enable_service_setup__hana       = false

#enable_app_subscription_setup__sap_launchpad    = false
#enable_app_subscription_setup__hana_cloud_tools = false
#enable_app_subscription_setup__cicd_app         = false

