######################################################################
# Entitlement for service
######################################################################
resource "btp_subaccount_entitlement" "name" {
  subaccount_id = var.subaccount_id
  service_name  = var.name
  plan_name     = var.plan
}

######################################################################
# Create service instances
######################################################################
module "create_cf_service_instance"{
  source        = "../../../modules/cloudfoundry-service-instance/"
  cf_space_id   = var.cf_space_id
  service_name  = var.name
  plan_name     = var.plan
  parameters    = var.parameters
  depends_on    = [btp_subaccount_entitlement.name]
}
