# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "~>0.51.3"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Fetch the technical ID of the service plan
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_service" "service" {
  name = var.service_name
}


# ------------------------------------------------------------------------------------------------------
# Create the service instance
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_service_instance" "service" {
  name         = var.service_name
  space        = var.cf_space_id
  service_plan = data.cloudfoundry_service.service.service_plans["${var.plan_name}"]
  json_params  = var.parameters
}