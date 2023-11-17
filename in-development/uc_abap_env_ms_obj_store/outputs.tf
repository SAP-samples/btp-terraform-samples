output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}


output "blob_storage_container_url" {
  value       = module.azure_storage.blob_storage_container_url
  description = "The URL of the storage container."
}
