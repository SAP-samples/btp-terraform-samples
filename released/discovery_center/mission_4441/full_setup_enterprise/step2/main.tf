# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "dev" {
  name = "dev"
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# SETUP ALL SERVICES FOR CF USAGE
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
# Setup sdm
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "sdm" {
  subaccount_id = var.subaccount_id
  service_name  = "sdm"
  plan_name     = "build-code"
}
# Create the service instance
data "cloudfoundry_service_plans" "sdm" {
  name       = "sdm"
  depends_on = [btp_subaccount_entitlement.sdm]
}
resource "cloudfoundry_service_instance" "sdm" {
  name         = "default_sdm"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.sdm.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.sdm]
}
# Create service key
resource "random_uuid" "service_key_sdm" {}
resource "cloudfoundry_service_credential_binding" "sdm" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_sdm.result])
  service_instance = cloudfoundry_service_instance.sdm.id
}

# ------------------------------------------------------------------------------------------------------
# Setup mobile-services
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "mobile_services" {
  subaccount_id = var.subaccount_id
  service_name  = "mobile-services"
  plan_name     = "build-code"
  amount        = 1
}
# Create the service instance
data "cloudfoundry_service_plans" "mobile_services" {
  name       = "mobile-services"
  depends_on = [btp_subaccount_entitlement.mobile_services]
}
resource "cloudfoundry_service_instance" "mobile_services" {
  name         = "default_mobile-services"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.mobile_services.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.mobile_services]
}
# Create service key
resource "random_uuid" "service_key_mobile_services" {}
resource "cloudfoundry_service_credential_binding" "mobile_services" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_mobile_services.result])
  service_instance = cloudfoundry_service_instance.mobile_services.id
}

# ------------------------------------------------------------------------------------------------------
# Setup transport (standard)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "transport_standard" {
  subaccount_id = var.subaccount_id
  service_name  = "transport"
  plan_name     = "standard"
}
# Create the service instance
data "cloudfoundry_service_plans" "transport_standard" {
  name       = "transport"
  depends_on = [btp_subaccount_entitlement.transport_standard]
}
resource "cloudfoundry_service_instance" "transport_standard" {
  name         = "default_transport_standard"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.transport_standard.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.transport_standard]
}
# Create service key
resource "random_uuid" "service_key_transport_standard" {}
resource "cloudfoundry_service_credential_binding" "transport_standard" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_transport_standard.result])
  service_instance = cloudfoundry_service_instance.transport_standard.id
}

# ------------------------------------------------------------------------------------------------------
# Setup transport (export)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "transport_export" {
  subaccount_id = var.subaccount_id
  service_name  = "transport"
  plan_name     = "export"
}
# Create the service instance
data "cloudfoundry_service_plans" "transport_export" {
  name       = "transport"
  depends_on = [btp_subaccount_entitlement.transport_export]
}
resource "cloudfoundry_service_instance" "transport_export" {
  name         = "default_transport_export"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.transport_export.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.transport_export]
}
# Create service key
resource "random_uuid" "service_key_transport_export" {}
resource "cloudfoundry_service_credential_binding" "transport_export" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_transport_export.result])
  service_instance = cloudfoundry_service_instance.transport_export.id
}

# ------------------------------------------------------------------------------------------------------
# Setup transport (operator)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "transport_operator" {
  subaccount_id = var.subaccount_id
  service_name  = "transport"
  plan_name     = "transport_operator"
}
# Create the service instance
data "cloudfoundry_service_plans" "transport_operator" {
  name       = "transport"
  depends_on = [btp_subaccount_entitlement.transport_operator]
}
resource "cloudfoundry_service_instance" "transport_operator" {
  name         = "default_transport_operator"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.transport_operator.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.transport_operator]
}
# Create service key
resource "random_uuid" "service_key_transport_operator" {}
resource "cloudfoundry_service_credential_binding" "transport_operator" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_transport_operator.result])
  service_instance = cloudfoundry_service_instance.transport_operator.id
}

# ------------------------------------------------------------------------------------------------------
# Setup cloud-logging
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "cloud_logging" {
  subaccount_id = var.subaccount_id
  service_name  = "cloud-logging"
  plan_name     = "build-code"
  amount        = 1
}
# Create the service instance
data "cloudfoundry_service_plans" "cloud_logging" {
  name       = "cloud-logging"
  depends_on = [btp_subaccount_entitlement.cloud_logging]
}
resource "cloudfoundry_service_instance" "cloud_logging" {
  name         = "default_cloud-logging"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.cloud_logging.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.cloud_logging]
}
# Create service key
resource "random_uuid" "service_key_cloud_logging" {}
resource "cloudfoundry_service_credential_binding" "cloud_logging" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_cloud_logging.result])
  service_instance = cloudfoundry_service_instance.cloud_logging.id
}

# ------------------------------------------------------------------------------------------------------
# Setup autoscaler
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "autoscaler" {
  subaccount_id = var.subaccount_id
  service_name  = "autoscaler"
  plan_name     = "standard"
}
data "cloudfoundry_service_plans" "autoscaler" {
  name       = "autoscaler"
  depends_on = [btp_subaccount_entitlement.autoscaler]
}
# Create the service instance
resource "cloudfoundry_service_instance" "autoscaler" {
  name         = "default_autoscaler"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.autoscaler.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.autoscaler]
}

# ------------------------------------------------------------------------------------------------------
# Setup feature-flags
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "feature_flags" {
  subaccount_id = var.subaccount_id
  service_name  = "feature-flags"
  plan_name     = "standard"
}
# Create the service instance
data "cloudfoundry_service_plans" "feature_flags" {
  name       = "feature-flags"
  depends_on = [btp_subaccount_entitlement.feature_flags]
}
resource "cloudfoundry_service_instance" "feature_flags" {
  name         = "default_feature-flags"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.feature_flags.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.feature_flags]
}
# Create service key
resource "random_uuid" "service_key_feature_flags" {}
resource "cloudfoundry_service_credential_binding" "feature_flags" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_feature_flags.result])
  service_instance = cloudfoundry_service_instance.feature_flags.id
}

# ------------------------------------------------------------------------------------------------------
# Setup alert-notification
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "alert_notification" {
  subaccount_id = var.subaccount_id
  service_name  = "alert-notification"
  plan_name     = "build-code"
  amount        = 1
}
# Create the service instance
data "cloudfoundry_service_plans" "alert_notification" {
  name       = "alert-notification"
  depends_on = [btp_subaccount_entitlement.alert_notification]
}
resource "cloudfoundry_service_instance" "alert_notification" {
  name         = "default_alert-notification"
  space        = cloudfoundry_space.dev.id
  type         = "managed"
  service_plan = data.cloudfoundry_service_plans.alert_notification.service_plans[0].id
  depends_on   = [cloudfoundry_space_role.space_manager, cloudfoundry_space_role.space_developer, cloudfoundry_org_role.organization_manager, btp_subaccount_entitlement.alert_notification]
}
# Create service key
resource "random_uuid" "service_key_alert_notification" {}
resource "cloudfoundry_service_credential_binding" "alert_notification" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_alert_notification.result])
  service_instance = cloudfoundry_service_instance.alert_notification.id
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign CF Org roles to the admin users
# ------------------------------------------------------------------------------------------------------
# Define Org User role
resource "cloudfoundry_org_role" "organization_user" {
  for_each = toset("${var.cf_org_admins}")
  username = each.value
  type     = "organization_user"
  org      = var.cf_org_id
  origin   = var.origin_key
}
# Define Org Manager role
resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset("${var.cf_org_admins}")
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_user]
}

# ------------------------------------------------------------------------------------------------------
# Assign CF space roles to the users
# ------------------------------------------------------------------------------------------------------
# Define Space Manager role
resource "cloudfoundry_space_role" "space_manager" {
  for_each = toset(var.cf_space_managers)

  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.dev.id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}
# Define Space Developer role
resource "cloudfoundry_space_role" "space_developer" {
  for_each = toset(var.cf_space_managers)

  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.dev.id
  origin     = var.origin_key
  depends_on = [cloudfoundry_org_role.organization_manager]
}
