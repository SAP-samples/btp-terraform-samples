output "sap_build_apps_runtime_url"{
    value       = "https://${var.subaccount_cf_org}.cr1.${var.region}.apps.build.cloud.sap/"
    description = "SAP Build Apps runtime URL."
}