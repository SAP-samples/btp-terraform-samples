output "subaccount_id" {
  value       = btp_subaccount.project.id
  description = "The ID of the project subaccount."
}

output "subaccount_name" {
  value       = btp_subaccount.project.name
  description = "The name of the project subaccount."
}

output "cloudfoundry_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the cloudfoundry org connected to the project account."
}

#output "url_sap_build_apps" {
#  value       = module.sap-build-apps_standard.url_sap_build_apps
#  description = "The url for the destination to the SAP Build Apps."
#}
