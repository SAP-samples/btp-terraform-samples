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
# Creation of Cloudfoundry environment
# ------------------------------------------------------------------------------------------------------
module "cloudfoundry_environment" {
  source                  = "../../../../modules/environment/cloudfoundry/envinstance_cf"
  subaccount_id           = btp_subaccount.build_code.id
  instance_name           = join("-", ["cf-", random_id.subaccount_domain_suffix.hex])
  plan_name               = "standard"
  cf_org_name             = join("-", ["cf-org", random_id.subaccount_domain_suffix.hex])
  cf_org_auditors         = []
  cf_org_billing_managers = []
  cf_org_managers         = []
}

# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
module "cloudfoundry_space" {
  source              = "../../../../modules/environment/cloudfoundry/space_cf"
  cf_org_id           = module.cloudfoundry_environment.cf_org_id
  name                = "dev"
  cf_space_managers   = []
  cf_space_developers = []
  cf_space_auditors   = []
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
  name           = "cicd-service-instance"
  depends_on     = [btp_subaccount_entitlement.cicd_service]
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
