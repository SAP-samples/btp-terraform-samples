output "AICORE_LLM_AUTH_URL" {
  value       = jsondecode(btp_subaccount_service_binding.ai_core_binding.credentials)["url"]
  description = "The binding keys to the SAP AI Core service."
  sensitive = true
}

output "AICORE_LLM_CLIENT_ID" {
  value       = jsondecode(btp_subaccount_service_binding.ai_core_binding.credentials)["clientid"]
  description = "The binding keys to the SAP AI Core service."
  sensitive = true
}

output "AICORE_LLM_CLIENT_SECRET" {
  value       = jsondecode(btp_subaccount_service_binding.ai_core_binding.credentials)["clientsecret"]
  description = "The binding keys to the SAP AI Core service."
  sensitive = true
}
output "AICORE_LLM_API_BASE" {
  value       = jsondecode(btp_subaccount_service_binding.ai_core_binding.credentials)["serviceurls"]["AI_API_URL"]
  description = "The binding keys to the SAP AI Core service."
  sensitive = true
}

output "AICORE_LLM_RESOURCE_GROUP" {
  value       = "default"
  description = "The binding keys to the SAP AI Core service."
}

# output "HANA_DB_ADDRESS" {
#   value       = jsondecode(btp_subaccount_service_binding.hana_cloud.credentials)["host"]
#   description = "The metadata of the HANA Cloud service binding."
#   sensitive = true
# }

# output "HANA_DB_PORT" {
#   value       = jsondecode(btp_subaccount_service_binding.hana_cloud.credentials)["port"]
#   description = "The metadata of the HANA Cloud service binding."
#   sensitive = true
# }

# output "HANA_DB_USER" {
#   value       = "DBADMIN"
#   description = "The metadata of the HANA Cloud service binding."
#   sensitive = true
# }

# output "HANA_DB_PASSWORD" {
#   value       = var.hana_system_password
#   description = "The metadata of the HANA Cloud service binding."
#   sensitive = true
# }

output "target_ai_core_model" {
  value       = var.target_ai_core_model
  description = "Defines the target AI core model to be used by the AI Core service."
}
