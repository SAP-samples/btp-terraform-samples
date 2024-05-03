# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
# ------------------------------------------------------------------------------------------------------
resource "random_id" "subaccount_domain_suffix" {
  byte_length = 12
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "build_code" {
  name      = var.subaccount_name
  subdomain = join("-", ["sap-build-code", random_id.subaccount_domain_suffix.hex])
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Entitle all services
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "entitlements" {
  subaccount_id = btp_subaccount.build_code.id
  for_each = {
    for index, entitlement in var.build_code_services :
    index => entitlement
  }
  service_name  = each.value.name
  plan_name     = each.value.plan
  amount        = each.value.amount
}
