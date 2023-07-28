# Create a subscription to the SAP Build Apps
resource "btp_subaccount_subscription" "sap-build-apps_standard" {
  subaccount_id = var.subaccount_id
  app_name      = "sap-appgyver-ee"
  plan_name     = "standard"
}

module "read_roles" {
  source = "../read_roles"
  subaccount_id = var.subaccount_id
  depends_on    = [btp_subaccount_subscription.sap-build-apps_standard]
}

# Create the role collections and assign them to the respective role
resource "btp_subaccount_role_collection" "sap-build-apps_standard" {

  for_each = module.read_roles.sap_build_apps_role_list

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
