# Read the subaccount data
data "btp_subaccount" "my_account" {
  id = var.subaccount_id
}


# Read the entiltement data
data "btp_subaccount_entitlements" "all" {
  subaccount_id = var.subaccount_id
}

# Extract the reight entry from all entitlements
locals {
  result = {
    for entitlement in data.btp_subaccount_entitlements.all.values : entitlement.service_name => entitlement
    if entitlement.service_name == var.service_name && entitlement.plan_name == var.service_plan_name
  }
}
