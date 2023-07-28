variable "subaccount_id" {
  type        = string
  description = "The subaccount id"
}

variable "for_sap_build_apps_roles_to_create"{
  type        = list(string)
  description = "Defines the roles assigned to the SAP Build Apps"
  default     = ["BuildAppsAdmin", "BuildAppsDeveloper", "RegistryAdmin", "RegistryDeveloper"]
}

