# Get all roles in the subaccount
data "btp_subaccount_roles" "all" {
  subaccount_id = var.subaccount_id
}

# Select those roles needed for the creation of the Role Collections
# for SAP Build Apps
locals {
  role_details_BuildAppsAdmin ={
    for name, role in data.btp_subaccount_roles.all.values : name => role
    if role.name == "BuildAppsAdmin"
  }

  /*
  role_details_sap_build_tools = {
    for name, role in data.btp_subaccount_roles.all.values : name => role
    if contains(toset(var.for_sap_build_apps_roles_to_create), role.name)
  }*/
}