# ------------------------------------------------------------------
# Terraform variables
# ------------------------------------------------------------------
# BTP Provider
BTP_PROVIDER_MANDATORY_VARIABLES = ["globalaccount", "region", "custom_idp", "cli_server_url",
                                    "subaccount_admins", "subaccount_service_admins", "subaccount_name", "subaccount_id"]
QAS_STEP1_BTP_PROVIDER_MANDATORY_VARIABLES = ["cf_org_admins", "cf_org_name", "cf_space_developers", "cf_space_managers", "cf_space_name", "cli_server_url",
                                              "custom_idp", "globalaccount", "region", "subaccount_admins", "subaccount_service_admins", "subaccount_name", "subaccount_id", "cf_landscape_label", "origin"]
QAS_STEP2_BTP_PROVIDER_MANDATORY_VARIABLES = []

# Cloudfoundry Provider
CF_PROVIDER_MANDATORY_VARIABLES = ["cf_org_admins", "cf_org_name", "cf_space_developers", "cf_landscape_label",
                                   "cf_org_id", "cf_api_url", "cf_space_managers", "cf_space_name", "cli_server_url", "origin"]
QAS_STEP1_CF_PROVIDER_MANDATORY_VARIABLES = []
QAS_STEP2_CF_PROVIDER_MANDATORY_VARIABLES = [
    "cf_api_url", "cf_org_id", "subaccount_id"]
