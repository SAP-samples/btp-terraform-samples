# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = "space"
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Prepare the list of admins and roles for the CF Org 
# ------------------------------------------------------------------------------------------------------
locals {
  role_mapping_admins_org = distinct(flatten([
    for admin in var.admins : [
      for role in var.roles_cf_org : {
        user_name = admin
        role_name = role
      }
    ]
    ]
  ))
}
locals {
  role_mapping_admins_space = distinct(flatten([
    for admin in var.admins : [
      for role in var.roles_cf_space : {
        user_name = admin
        role_name = role
      }
    ]
    ]
  ))
}



# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Org Manager role
resource "cloudfoundry_org_role" "all_org_roles" {

  for_each = { for entry in local.role_mapping_admins_org : "${entry.user_name}.${entry.role_name}" => entry }

  username = each.value.user_name
  type     = each.value.role_name
  org      = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Assign CF space roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Space Manager role
resource "cloudfoundry_space_role" "my_role" {
  for_each = { for entry in local.role_mapping_admins_space : "${entry.user_name}.${entry.role_name}" => entry }

  username   = each.value.user_name
  type       = each.value.role_name
  space      = cloudfoundry_space.space.id
  depends_on = [cloudfoundry_org_role.all_org_roles]
}
