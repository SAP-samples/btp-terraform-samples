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
# Prepare and setup app: SAP Build Code
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "build-code"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: Cloud Transport Management
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "alm_ts" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "alm-ts"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: Continuous Integration & Delivery
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "cicd_app" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "cicd-app"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: SAP Business Application Studio
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "sapappstudio" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: SAP Build Work Zone, standard edition
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "SAPLaunchpad" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = "foundation"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup app: Document Management Service, Application Option
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "sdm_web" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sdm-web"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Alert Notification
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "alert_notification" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "alert-notification"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Application Autoscaler
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "alert_notification" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "autoscaler"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Continuous Integration & Delivery
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "cicd_service" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "cicd-service"
  plan_name     = "default"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Cloud Logging
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "cloud_logging" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "cloud-logging"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Feature Flags Service
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "feature_flags" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "feature-flags"
  plan_name     = "standard"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Mobile Services
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "cloud_logging" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "mobile-services"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Document Management Service, Integration Option
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "cloud_logging" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sdm"
  plan_name     = "build-code"
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: Cloud Transport Management
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount
resource "btp_subaccount_entitlement" "transport" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "transport"
  plan_name     = "standard"
}
