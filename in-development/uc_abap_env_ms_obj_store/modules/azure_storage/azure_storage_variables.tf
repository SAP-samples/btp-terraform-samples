variable "rg_name" {
  description = "The name of the resource group in Azure"
  type        = string
}

variable "location" {
  description = "The location of the resource group in Azure"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account in Azure"
  type        = string

}

variable "account_tier" {
  description = "The tier of the storage account in Azure"
  type        = string
  default     = "Standard"
}

variable "account_replication_type" {
  description = "The replication type of the storage account in Azure"
  type        = string
  default     = "LRS"
}


variable "container_name" {
  description = "The name of the storage container in Azure"
  type        = string
}

variable "container_access_type" {
  description = "The access type of the storage container in Azure"
  type        = string
  default     = "private"
}
