data "cloudfoundry_service" "service" {
  name = var.service_name
}

resource "cloudfoundry_service_instance" "service" {
  name         = var.service_name
  space        = var.cf_space_id
  service_plan = data.cloudfoundry_service.service.service_plans["${var.plan_name}"]
}