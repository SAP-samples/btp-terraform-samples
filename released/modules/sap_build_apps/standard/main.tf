# Create a subscription to the SAP Build Apps
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = var.subaccount_id
  app_name      = "sap-appgyver-ee"
  plan_name     = "standard"
}

# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = var.subaccount_id
  depends_on    = [btp_subaccount_subscription.sap-build-apps_standard]
}

# Select those roles needed for the creation of the Role Collections
# for SAP Build Apps
locals {
  role_details_sap_build_tools = {
    for name, role in data.btp_subaccount_roles.all.values : name => role 
    if contains(toset(var.for_sap_build_apps_roles_to_create), role.name)
  }
}

# Create the role collections and assign them to the respective role
resource "btp_subaccount_role_collection" "sap-build-apps_standard" {
  for_each = local.role_details_sap_build_tools
      subaccount_id = var.subaccount_id
      name          = each.value.name
      description   = "Role collection ${each.value.name} for SAP Build Apps"

      roles = [
        {
          name                 = each.value.name
          role_template_app_id = each.value.app_id
          role_template_name   = each.value.name
        }
      ]
}
