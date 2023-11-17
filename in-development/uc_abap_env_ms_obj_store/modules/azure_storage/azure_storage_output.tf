output "blob_storage_container_url" {
  value = "https://${azurerm_storage_account.abap_storage.name}.blob.core.windows.net/${azurerm_storage_container.abap_storage.name}/"
  description = "The URL of the storage container."
}
