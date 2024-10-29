locals {
  user_assignments = [
    for role in var.role_collection_assignments : [
      for user in role.users : {
        role_collection_name = role.role_collection_name
        user_name            = user
      }
    ]
  ]
}

resource "btp_subaccount_role_collection_assignment" "role_collection_assignment" {
  for_each = { for idx, assignment in flatten(local.user_assignments) : "${assignment.role_collection_name}-${assignment.user_name}" => assignment }

  subaccount_id        = var.subaccount_id
  role_collection_name = each.value.role_collection_name
  user_name            = each.value.user_name
}