# Create Cloud Foundry space and assign users
module "cloudfoundry_space" {
  source              = "../modules/cloudfoundry-space/"
  cf_org_id           = var.cf_org_id
  name                = var.subaccount_cf_space
  cf_space_managers   = var.cf_space_managers
  cf_space_developers = var.cf_space_developers
  cf_space_auditors   = var.cf_space_auditors
}

module "setup_cf_service_destination" {
  source              = "../modules/cloudfoundry-service-instance/"
  cf_space_id         = module.cloudfoundry_space.id
  service_name        = "destination"
  plan_name           = "lite"
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          {
            Name = "SAP-Build-Apps-Runtime"
            Type = "HTTP"
            Description = "Endpoint to SAP Build Apps runtime"
            URL = "https://${var.subaccount_cf_org}.cr1.${var.region}.apps.build.cloud.sap/"
            ProxyType = "Internet"
            Authentication = "NoAuthentication"
            "HTML5.ForwardAuthToken" = true
          }
        ]
      }
    }
  })
}
