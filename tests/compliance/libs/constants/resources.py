# ------------------------------------------------------------------
# Terraform resources
# ------------------------------------------------------------------
# BTP Provider
BTP_PROVIDER_MANDATORY_RESOURCES = [
    "btp_subaccount", "btp_subaccount_trust_configuration"]

# Cloudfoundry Provider
CF_PROVIDER_MANDATORY_RESOURCES = [
    "cloudfoundry_space", "cloudfoundry_org_role", "cloudfoundry_space_role"]
