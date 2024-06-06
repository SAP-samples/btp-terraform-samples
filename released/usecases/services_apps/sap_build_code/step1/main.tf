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
}
# Create service instance
resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = btp_subaccount.build_code.id
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  name           = "destination"
  depends_on     = [btp_subaccount_service_binding.cicd_service]
    parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          {
            Description = "[Do not delete] SAP Continuous Integration and Delivery"
            Type = "HTTP"
            clientId = "${btp_subaccount_service_binding.cicd_service["uaa"]["clientid"]}"
            "HTML5.DynamicDestination" = true
            Authentication = "OAuth2JWTBearer"
            Name = "cicd-backend"
            tokenServiceURL = "${btp_subaccount_service_binding.cicd_service["uaa"]["url"]}"
            ProxyType = "Internet"
            URL =  "${btp_subaccount_service_binding.cicd_service["url"]}"
            tokenServiceURLType = "Dedicated"
          }
        ]
      }
    }
  })
}


{
  "uaa": {
    "apiurl": "https://api.authentication.us10.hana.ondemand.com",
    "clientid": "sb-13e4ff75-668f-4cce-bd8d-bcaba24534bf!b291653|cicdservice!b5250",
    "clientsecret": "01fd1df3-df8f-4c85-a780-a0931ac208ca$rLCnhtZ2J5JaCCWMnNudlQ6hQa-jgs7VP_qQOcd38X4=",
    "credential-type": "binding-secret",
    "identityzone": "qh4nfwr7cd2vgn1f",
    "identityzoneid": "11e9aea4-23f9-437b-9090-057c8c60e4e6",
    "sburl": "https://internal-xsuaa.authentication.us10.hana.ondemand.com",
    "serviceInstanceId": "13e4ff75-668f-4cce-bd8d-bcaba24534bf",
    "subaccountid": "11e9aea4-23f9-437b-9090-057c8c60e4e6",
    "tenantid": "11e9aea4-23f9-437b-9090-057c8c60e4e6",
    "tenantmode": "shared",
    "uaadomain": "authentication.us10.hana.ondemand.com",
    "url": "https://qh4nfwr7cd2vgn1f.authentication.us10.hana.ondemand.com",
    "verificationkey": "-----BEGIN PUBLIC KEY-----\nMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAjrAMl7d9t4CqVr3SB27f\n7kofW/7k0mijLsFqGZbacHYNtupVMy3g3zTkqLCJiK5P2hLuNBrejXiheP/jR9BQ\nRZXbwuHsMmvuh1qKM7Fx/NlJ130CAB5XmqtaFiWHtqoboQIoHtmYSX1mzdxlq7Qo\nFGiELZwO4wRlD7bn+7xmZG3yQwO/qzcsDQ1Lr3w7NneDnBiNz5Vpsenw0a48Fjlq\nSuqgGCI/VsB45FcPAtH3sspJnCWjsa8kd5DD/6vbe1Xtc2asOn5g5Nr4TY0fufmP\n/4f408BPSW8dqJEyHJeP50P1keCEG7p9ahbBmcHBWp+p0lRLrI+Oae92bLXx+1RO\nFwIDAQAB\n-----END PUBLIC KEY-----",
    "xsappname": "13e4ff75-668f-4cce-bd8d-bcaba24534bf!b291653|cicdservice!b5250",
    "zoneid": "11e9aea4-23f9-437b-9090-057c8c60e4e6"
  },
  "url": "https://cicd-service.cfapps.us10.hana.ondemand.com",
  "vendor": "SAP"
}
Description=[Do not delete] SAP Continuous Integration and Delivery
Type=HTTP
clientId=sb-13e4ff75-668f-4cce-bd8d-bcaba24534bf\!b291653|cicdservice\!b5250
HTML5.DynamicDestination=true
Authentication=OAuth2JWTBearer
Name=cicd-backend
tokenServiceURL=https\://qh4nfwr7cd2vgn1f.authentication.us10.hana.ondemand.com/oauth/token
ProxyType=Internet
URL=https\://cicd-service.cfapps.us10.hana.ondemand.com
tokenServiceURLType=Dedicated

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
  globalaccount      = "${var.globalaccount}"
  cli_server_url     = ${jsonencode(var.cli_server_url)}

  subaccount_id      = "${btp_subaccount.build_code.id}"

  cf_api_endpoint    = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]}"
  cf_org_id          = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]}"
  cf_org_name        = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]}"

  identity_provider  = "${var.identity_provider}"

  cf_org_admins      = ${jsonencode(var.cf_org_admins)}
  cf_space_developer = ${jsonencode(var.cf_space_developer)}
  cf_space_manager   = ${jsonencode(var.cf_space_manager)}
  EOT
  filename = "../step2/terraform.tfvars"
}