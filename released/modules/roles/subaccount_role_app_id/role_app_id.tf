terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "~> 1.9.0"
    }
  }
}

data "btp_subaccount_roles" "all_roles" {
  subaccount_id = var.subaccount_id
}


locals {
  selected_role = [
    for role in data.btp_subaccount_roles.all_roles.values : role
    if role.name == var.role_name && role.role_template_name == var.var.role_template_name
  ]
}
