###############################################################################################
# Setup subaccount domain and the CF org (to ensure uniqueness in BTP global account)
###############################################################################################
locals {
  project_subaccount_domain = lower("${var.subaccount_name}")
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}${var.org}", "-", ""),0,32)
}

resource "btp_directory" "proj" {
  name        = var.directory
  description = var.directory_desc
  features    = ["DEFAULT"]
  labels = var.directory_labels
}
 
###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "create_subaccount" {
  count = var.subaccount_id == "" ? 1 : 0
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  parent_id = btp_directory.proj.id
  region    = lower(var.region)
  labels    = var.subaccount_labels
}

data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.create_subaccount[0].id
}

data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.project.id
}


 
###############################################################################################
# Assign custom IDP to subaccount
###############################################################################################

resource "btp_subaccount_trust_configuration" "simple" {
  count = var.custom_idp != "" ? 1 : 0
  subaccount_id     = data.btp_subaccount.project.id
  identity_provider = var.custom_idp
}

locals {
  default_origin = var.origin != "" ? var.origin : "sap.ids"
}


###############################################################################################
# Subaccount role settings
###############################################################################################

resource "btp_subaccount_role_collection_assignment" "subaccount-administrators" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  origin               = local.default_origin
  depends_on           = [btp_subaccount.create_subaccount]
}

resource "btp_subaccount_role_collection_assignment" "subaccount-viewer" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Viewer"
  for_each             = toset(var.developers)
  user_name            = each.value
  origin               = local.default_origin
  depends_on           = [btp_subaccount.create_subaccount]
}

###############################################################################################
# Creation of Cloud Foundry environment
###############################################################################################


# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# ------------------------------------------------------------------------------------------------------
resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.environment_label) > 0 ? var.environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = data.btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
  depends_on = [ btp_subaccount_role_collection_assignment.subaccount-administrators,btp_subaccount_role_collection_assignment.subaccount-viewer ]
}

resource "cloudfoundry_org_role" "manager" {
  for_each = toset(var.admins)
  username = each.value
  type     = "organization_manager"
  org      = btp_subaccount_environment_instance.cf.platform_id
  origin   = local.default_origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}

resource "cloudfoundry_org_role" "user" {
  for_each = toset(var.developers)
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cf.platform_id
  origin   = local.default_origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}
resource "cloudfoundry_org_role" "user_admins" {
  for_each = toset(var.admins)
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cf.platform_id
  origin   = local.default_origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}
resource "cloudfoundry_space" "space" {
  name      = var.cf_space
  org       = btp_subaccount_environment_instance.cf.platform_id
  labels    = { test : "pass", purpose : "prod" }
  depends_on = [ btp_subaccount_environment_instance.cf, cloudfoundry_org_role.user_admins,cloudfoundry_org_role.user]
}


resource "cloudfoundry_space_role" "space_manager" {
  for_each = toset(var.admins)
  username = each.value
  type     = "space_manager"
  space    = cloudfoundry_space.space.id
  origin   = local.default_origin
  depends_on = [ cloudfoundry_space.space ]
}

resource "cloudfoundry_space_role" "space_developers" {
  for_each = toset(var.developers)
  username = each.value
  type     = "space_developer"
  space    = cloudfoundry_space.space.id
  origin   = local.default_origin
  depends_on = [ cloudfoundry_space.space ]
}



###############################################################################################
# Prepare and setup app: Continuous Integration & Delivery
###############################################################################################
# Entitle subaccount for usage of app Continuous Integration & Delivery
resource "btp_subaccount_entitlement" "cicd_app" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "cicd-app"
  plan_name     = var.cicd_service_plan
}

# Entitle subaccount for usage of service Continuous Integration & Delivery
resource "btp_subaccount_entitlement" "cicd_service" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "cicd-service"
  plan_name     = "default"
}

# Create app subscription for Continuous Integration & Delivery (depends on entitlement)
resource "btp_subaccount_subscription" "cicd_app" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "cicd-app"
  plan_name     = var.cicd_service_plan
  depends_on    = [btp_subaccount_entitlement.cicd_app]
}

# Create a service instance and service binding of the CI/CD service (for API handling)
data "btp_subaccount_service_plan" "cicd_service" {
  subaccount_id = data.btp_subaccount.project.id
  offering_name = "cicd-service"
  name          = "default"
  depends_on    = [btp_subaccount_entitlement.cicd_service]
} 
resource "btp_subaccount_service_instance" "cicd_service" {
  subaccount_id  = data.btp_subaccount.project.id
  serviceplan_id = data.btp_subaccount_service_plan.cicd_service.id
  name           = "cicdservice"
  parameters     = jsonencode({"data" : { "role" : "administrator" }})
  depends_on     = [btp_subaccount_subscription.cicd_app]
}

resource "btp_subaccount_service_binding" "cicd_binding" {
  subaccount_id       = data.btp_subaccount.project.id
  service_instance_id = btp_subaccount_service_instance.cicd_service.id
  name                = "cicd_binding"
}

# Map user to CI/CD roles
resource "btp_subaccount_role_collection_assignment" "cicdadmin" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd_app]
}

resource "btp_subaccount_role_collection_assignment" "cicddev" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Developer"
  for_each             = toset(var.developers)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd_app]
}
###########################################################################
#Automation Pilot
###########################################################################

resource "btp_subaccount_entitlement" "auto_pilot" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "automationpilot"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "auto_pilot" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "automationpilot"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.auto_pilot]
}

resource "btp_subaccount_role_collection_assignment" "apadmin" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "AutomationPilot_Admin"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.auto_pilot]
}

resource "btp_subaccount_role_collection_assignment" "apdev" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "AutomationPilot_Developer"
  for_each             = toset(var.developers)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.auto_pilot]
}

#######################################################################
# Business Application Studio
#######################################################################
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = "standard-edition"
  depends_on    = [btp_subaccount_trust_configuration.simple]
 }

 # Create app subscription to SAP Build Apps (depends on entitlement)
resource "btp_subaccount_subscription" "bas-subscribe" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "sapappstudio"
  plan_name     = btp_subaccount_entitlement.bas.plan_name
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  for_each             = toset(var.developers)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}
resource "btp_subaccount_role_collection_assignment" "bas_admin" {
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}



########################################################################
# HANA Cloud 
########################################################################
resource "btp_subaccount_entitlement" "hana-cloud-tools" {
  subaccount_id    =  data.btp_subaccount.project.id
  service_name     = "hana-cloud-tools"
  plan_name        = "tools"
}
resource "btp_subaccount_subscription" "hana-cloud-tools" {
  subaccount_id    =  data.btp_subaccount.project.id
  app_name         = "hana-cloud-tools"
  plan_name        = "tools"
  depends_on       = [btp_subaccount_entitlement.hana-cloud-tools]
}

resource "btp_subaccount_entitlement" "hana_hdi_shared" {
  subaccount_id =  data.btp_subaccount.project.id
  service_name  = "hana"
  plan_name     = "hdi-shared"
}

resource "btp_subaccount_role_collection_assignment" "hana_admin" {
  subaccount_id        =  data.btp_subaccount.project.id
  role_collection_name = "SAP HANA Cloud Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on  = [btp_subaccount_subscription.hana-cloud-tools]
}


resource "btp_subaccount_role_collection_assignment" "hana_viewer" {
  subaccount_id        =  data.btp_subaccount.project.id
  role_collection_name = "SAP HANA Cloud Viewer"
  for_each             = toset(var.developers)
  user_name            = each.value
  depends_on  = [btp_subaccount_subscription.hana-cloud-tools]
}

resource "btp_subaccount_role_collection_assignment" "hana_security" {
  subaccount_id        =  data.btp_subaccount.project.id
  role_collection_name = "SAP HANA Cloud Security Administrator"
  for_each             = toset(var.admins)
  user_name            = each.value
  depends_on  = [btp_subaccount_subscription.hana-cloud-tools]
}

resource "btp_subaccount_entitlement" "hana_cloud" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}

# Get plan for SAP HANA Cloud
data "btp_subaccount_service_plan" "hana_cloud" {
  subaccount_id = data.btp_subaccount.project.id
  offering_name = "hana-cloud"
  name          = "hana"
  depends_on    = [btp_subaccount_entitlement.hana_cloud]  
}

# # Create service instance for SAP HANA Cloud
# resource "btp_subaccount_service_instance" "hana_cloud"{
#   subaccount_id  = data.btp_subaccount.project.id
#   serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
#   name           = var.hana_db_name
#   depends_on     = [btp_subaccount_entitlement.hana_cloud]
#   parameters     = jsonencode(
#     { "data" : { 
#         "memory":16,
#         "edition":"cloud",
#         "systempassword": "${var.hana_system_password}",
#         "additionalWorkers":0,
#         "dataEncryption":{"mode":"DEDICATED_KEY"},
#         "disasterRecoveryMode":"no_disaster_recovery",
#         "enabledservices":{
#           "docstore":false,
#           "dpserver":true,
#           "scriptserver":false
#         },
#         "productVersion":{
#           "releaseCycle":"pre-release-quarterly",
#           "track":"2024.2"
#         },
#         "requestedOperation":{},
#         "serviceStopped":false,
#         "slaLevel":"standard",
#         "storage":80,
#         "updateStrategy":"withRestart",
#         "vcpu":1,
#         "whitelistIPs":["0.0.0.0/0"]
#       }
#   }) 
#  }

