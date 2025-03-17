locals {
  flattened_role_collection_assignments = flatten([
    for index, role_collection_assignment in var.role_collection_assignments : [
      for index, user in role_collection_assignment.users : {
        role_collection_name = role_collection_assignment.role_collection_name
        user                 = user
      }
    ]
  ])
}

resource "btp_directory" "self" {
  name        = var.directory_name
  description = var.directory_description
  features    = toset(var.features)
  labels = {
    "managed_by" = ["terraform"]
    "scope"      = ["integration"]
    "costcenter" = [var.project_costcenter]
  }
}

resource "btp_directory_entitlement" "dir_entitlement_assignment" {
  for_each     = { for e in var.entitlement_assignments : e.name => e }
  directory_id = btp_directory.self.id
  service_name = each.value.name
  plan_name    = each.value.plan
  amount       = each.value.amount != 0 ? each.value.amount : null
  distribute   = each.value.distribute
  auto_assign  = each.value.auto_assign
}


resource "btp_directory_role_collection_assignment" "dir_role_collection_assignment" {
  for_each             = { for index, role_collection_assignment in local.flattened_role_collection_assignments : index => role_collection_assignment }
  directory_id         = btp_directory.self.id
  role_collection_name = each.value.role_collection_name
  user_name            = each.value.user
}
