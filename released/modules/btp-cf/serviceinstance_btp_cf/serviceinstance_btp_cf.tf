# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "~> 1.0.0"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Fetch the technical ID of the service plan
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_service_plans" "service" {
  name = var.service_name
}


# ------------------------------------------------------------------------------------------------------
# Create the service instance
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_instance" "service" {
  name         = var.service_name
  space        = var.cf_space_id
  service_plan = data.cloudfoundry_service_plans.service.service_plans[0].id
  type         = var.type
  parameters   = var.parameters
}