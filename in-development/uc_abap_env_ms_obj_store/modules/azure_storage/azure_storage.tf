terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~>3.81.0"
    }
  }
}

# Create a Resource Group if it doesn’t exist
resource "azurerm_resource_group" "abap_rg" {
  name     = var.rg_name
  location = var.location
}

# Create a Storage account
resource "azurerm_storage_account" "abap_storage" {
  name                     = var.storage_account_name
  resource_group_name      = azurerm_resource_group.abap_rg.name
  location                 = azurerm_resource_group.abap_rg.location
  account_tier             = var.account_tier
  account_replication_type = var.account_replication_type

  tags = {
    environment = "test"
  }
}

# Create a Storage container
resource "azurerm_storage_container" "abap_storage" {
  name                  = var.container_name
  storage_account_name  = azurerm_storage_account.abap_storage.name
  container_access_type = var.container_access_type
}
