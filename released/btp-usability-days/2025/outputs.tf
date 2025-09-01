output "subaccount_url" {
  value       = "https://emea.cockpit.btp.cloud.sap/cockpit/#globalaccount/${data.btp_globalaccount.self.id}/subaccount/${btp_subaccount.self.id}"
  description = "The SAP BTP subaccount URL"
}

output "cf_api_url" {
  value       = jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]
  description = "The Cloud Foundry API URL"
}
