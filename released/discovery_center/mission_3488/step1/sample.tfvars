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

sac_admin_email      = "<<sac.admin@acme.com>>"
sac_admin_first_name = "First Name"
sac_admin_last_name  = "Last Name"
sac_admin_host_name  = "<<sac-hostname>>"

# ------------------------------------------------------------------------------------------------------
# additional configuration (dev & testing)
# ------------------------------------------------------------------------------------------------------
create_tfvars_file_for_step2 = true

# (optional) test enable/disable service setups
#enable_service_setup__sac = false