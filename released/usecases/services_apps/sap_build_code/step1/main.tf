# ------------------------------------------------------------------------------------------------------
# SUBACCOUNT SETUP
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
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
# CLOUDFOUNDRY PREPARATION
# ------------------------------------------------------------------------------------------------------
#
# Fetch all available environments for the subaccount
data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.build_code.id
}
# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# (this replaces the previous null_resource)
# ------------------------------------------------------------------------------------------------------
resource "terraform_data" "replacement" {
  input = length(var.cf_environment_label) > 0 ? var.cf_environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
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
  landscape_label  = terraform_data.replacement.output

  parameters = jsonencode({
    instance_name = "cf-${random_id.subaccount_domain_suffix.hex}"
  })
}

# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
#
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
  # Subscription to the cicd-app subscription is required for creating the service instance
  # See as well https://help.sap.com/docs/continuous-integration-and-delivery/sap-continuous-integration-and-delivery/optional-enabling-api-usage?language=en-US
  depends_on = [btp_subaccount_subscription.cicd_app]
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
# Setup destination
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = btp_subaccount.build_code.id
  service_name  = "destination"
  plan_name     = "lite"
}
# Get serviceplan_id for cicd-service with plan_name "default"
data "btp_subaccount_service_plan" "destination" {
  subaccount_id = btp_subaccount.build_code.id
  offering_name = "destination"
  name          = "lite"
  depends_on    = [btp_subaccount_entitlement.destination]
}
# Create service instance
resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = btp_subaccount.build_code.id
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  name           = "destination"
  depends_on     = [btp_subaccount_service_binding.cicd_service, data.btp_subaccount_service_plan.destination]
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          # This is the destination to the cicd-service binding
          {
            Description                = "[Do not delete] SAP Continuous Integration and Delivery"
            Type                       = "HTTP"
            clientId                   = "${jsondecode(btp_subaccount_service_binding.cicd_service.credentials)["uaa"]["clientid"]}"
            clientSecret               = "${jsondecode(btp_subaccount_service_binding.cicd_service.credentials)["uaa"]["clientsecret"]}"
            "HTML5.DynamicDestination" = true
            Authentication             = "OAuth2JWTBearer"
            Name                       = "cicd-backend"
            tokenServiceURL            = "${jsondecode(btp_subaccount_service_binding.cicd_service.credentials)["uaa"]["url"]}"
            ProxyType                  = "Internet"
            URL                        = "${jsondecode(btp_subaccount_service_binding.cicd_service.credentials)["url"]}"
            tokenServiceURLType        = "Dedicated"
          }
        ]
      }
    }
  })
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
# Subscribe
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
# Subscribe (depends on subscription of build-code)
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
# Subscribe
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
# Subscribe
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
# Subscribe
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
# Subscribe
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
# Subscribe
resource "btp_subaccount_subscription" "sdm-web" {
  subaccount_id = btp_subaccount.build_code.id
  app_name      = "sdm-web"
  plan_name     = "build-code"
  depends_on    = [btp_subaccount_subscription.build_code, btp_subaccount_entitlement.sdm-web]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# Get all available subaccount roles
data "btp_subaccount_roles" "all" {
  subaccount_id = btp_subaccount.build_code.id
  depends_on    = [btp_subaccount_subscription.alm_ts, btp_subaccount_subscription.build_code, btp_subaccount_subscription.cicd_app, btp_subaccount_subscription.sap_launchpad, btp_subaccount_subscription.sapappstudio, btp_subaccount_subscription.feature_flags_dashboard, btp_subaccount_subscription.sdm-web]
}
# ------------------------------------------------------------------------------------------------------
# Assign role collection for Build Code Administrator
# ------------------------------------------------------------------------------------------------------
# Assign roles to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection" "build_code_administrator" {
  subaccount_id = btp_subaccount.build_code.id
  name          = "Build Code Administrator"
  description   = "The role collection for an administrator on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Administrator", "Administrator", "FeatureFlags_Dashboard_Administrator", "RegistryAdmin"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection_assignment" "build_code_administrator" {
  for_each             = toset("${var.build_code_admins}")
  subaccount_id        = btp_subaccount.build_code.id
  role_collection_name = "Build Code Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Build Code Developer"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection" "build_code_developer" {
  subaccount_id = btp_subaccount.build_code.id
  name          = "Build Code Developer"
  description   = "The role collection for a developer on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Developer", "Developer", "FeatureFlags_Dashboard_Auditor", "RegistryDeveloper"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Developer"
resource "btp_subaccount_role_collection_assignment" "build_code_developer" {
  for_each             = toset("${var.build_code_developers}")
  subaccount_id        = btp_subaccount.build_code.id
  role_collection_name = "Build Code Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.build_code.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount.build_code]
}
