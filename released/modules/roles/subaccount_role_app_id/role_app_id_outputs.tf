output "role_app_id" {
  value       = local.selected_role[0].app_id
  description = "The id of the application that provides the role template and the role."
}
