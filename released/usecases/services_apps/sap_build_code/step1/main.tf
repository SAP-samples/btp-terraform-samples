# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
# ------------------------------------------------------------------------------------------------------
resource "random_id" "subaccount_domain_suffix" {
  byte_length = 12
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "build_code" {
  name      = var.subaccount_name
  subdomain = join("-", ["sap-build-code", random_id.subaccount_domain_suffix.hex])
  region    = lower(var.region)
}


# ------------------------------------------------------------------------------------------------------
# Fetch all available environments for the subaccount
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.build_code.id
}

# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# ------------------------------------------------------------------------------------------------------
resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.cf_environment_label) > 0 ? var.cf_environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry environment instance
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = btp_subaccount.build_code.id
  name             = "cf-${random_id.subaccount_domain_suffix.hex}"
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = "cf-${random_id.subaccount_domain_suffix.hex}"
  })
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Setup sdm
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "sdm" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "sdm"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Setup mobile-services
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "mobile_services" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "mobile-services"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Setup cloud-logging
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "cloud_logging" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "cloud-logging"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Setup alert-notification
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "alert_notification" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "alert-notification"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Setup transport
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "transport" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "transport"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Setup autoscaler
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "autoscaler" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "autoscaler"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Setup feature-flags
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "feature_flags" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "feature-flags"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Setup cicd-service (not running in CF environment)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "cicd_service" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "cicd-service"
  plan_name     = "default"
}
# Get serviceplan_id for cicd-service with plan_name "default"
data "btp_subaccount_service_plan" "cicd_service" {
  subaccount_id = btp_subaccount.build_code.id
  offering_name = "cicd-service"
  name          = "default"
  depends_on    = [btp_subaccount_entitlement.cicd_service]
}
# Create service instance
resource "btp_subaccount_service_instance" "cicd_service" {
  subaccount_id  = btp_subaccount.build_code.id
  serviceplan_id = data.btp_subaccount_service_plan.cicd_service.id
  name           = "default_cicd-service"
  depends_on     = [btp_subaccount_entitlement.cicd_service, btp_subaccount_environment_instance.cf]
}

# Create service key
resource "random_id" "service_key_cicd_service" {
  byte_length = 12
}
resource "btp_subaccount_service_binding" "cicd_service" {
  subaccount_id       = btp_subaccount.build_code.id
  service_instance_id = btp_subaccount_service_instance.cicd_service.id
  name                = join("_", ["defaultKey", random_id.service_key_cicd_service.hex])
  depends_on          = [btp_subaccount_service_instance.cicd_service]
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Setup build-code
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "build-code"
  plan_name     = "standard"
}
# subscribe
resource "btp_subaccount_subscription" "build_code" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "build-code"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.build_code]
}

# ------------------------------------------------------------------------------------------------------
# Setup sapappstudio
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sapappstudio" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "sapappstudio"
  plan_name     = "build-code"
}
# subscribe (depends on subscription of build-code)
resource "btp_subaccount_subscription" "sapappstudio" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "sapappstudio"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.sapappstudio]
}

# ------------------------------------------------------------------------------------------------------
# Setup SAPLaunchpad (SAP Build Work Zone, standard edition)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sap_launchpad" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "SAPLaunchpad"
  plan_name     = "standard"
}
# subscribe
resource "btp_subaccount_subscription" "sap_launchpad" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "SAPLaunchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.sap_launchpad]
}

# ------------------------------------------------------------------------------------------------------
# Setup cicd-app (Continuous Integration & Delivery)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "cicd_app" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "cicd-app"
  plan_name     = "build-code"
}
# subscribe
resource "btp_subaccount_subscription" "cicd_app" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "cicd-app"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.cicd_app]
}

# ------------------------------------------------------------------------------------------------------
# Setup alm-ts (Cloud Transport Management)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "alm_ts" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "alm-ts"
  plan_name     = "build-code"
}
# subscribe
resource "btp_subaccount_subscription" "alm_ts" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "alm-ts"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.alm_ts]
}

# ------------------------------------------------------------------------------------------------------
# Setup feature-flags-dashboard (Feature Flags Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "feature_flags_dashboard" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "feature-flags-dashboard"
  plan_name     = "dashboard"
}
# subscribe
resource "btp_subaccount_subscription" "feature_flags_dashboard" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "feature-flags-dashboard"
  plan_name     = "dashboard"
  depends_on    = [btp_subaccount_entitlement.feature_flags_dashboard]
}

# ------------------------------------------------------------------------------------------------------
# Setup sdm-web (Document Management Service)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "sdm-web" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "sdm-web"
  plan_name     = "build-code"
}
# subscribe
resource "btp_subaccount_subscription" "sdm-web" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "sdm-web"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_entitlement.sdm-web]
}

# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step2 with cf configuration
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  content       = <<-EOT
  cf_api_endpoint = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]}"
  cf_org_id       = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]}"
  cf_org_name     = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]}"
  admins          = ${jsonencode(var.admins)}
  EOT
  filename = "../step2/terraform.tfvars"
}