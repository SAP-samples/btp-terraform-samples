# ------------------------------------------------------------------------------------------------------
# Setup of names in accordance to naming convention
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-4172-${local.random_uuid}", "_", "-"))
  subaccount_cf_org = substr(replace("${local.subaccount_domain}", "-", ""), 0, 32)
}

locals {
  service__sap_business_app_studio     = "sapappstudio"
  service_name__hana_cloud_tools       = "hana-cloud-tools"
  service_name__sap_process_automation = "process-automation"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}


# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account (if custom_idp is set)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  # Only create trust configuration if custom_idp has been set 
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = data.btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp
}

locals {
  custom_idp_tenant    = var.custom_idp != "" ? element(split(".", var.custom_idp), 0) : ""
  origin_key           = local.custom_idp_tenant != "" ? "${local.custom_idp_tenant}-platform" : "sap.default"
  origin_key_app_users = var.custom_idp != "" ? var.custom_idp_apps_origin_key : "sap.default"
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset(var.subaccount_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  origin               = local.origin_key
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Assignment of users as sub account service administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset(var.subaccount_service_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Service Administrator"
  origin               = local.origin_key
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Extract list of CF landscape labels from environments
# ------------------------------------------------------------------------------------------------------
data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
}

# Take the landscape label from the first CF environment if no environment label is provided
resource "terraform_data" "cf_landscape_label" {
  input = length(var.cf_landscape_label) > 0 ? var.cf_landscape_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}

# ------------------------------------------------------------------------------------------------------
# Creation of Cloud Foundry environment
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = data.btp_subaccount.dc_mission.id
  name             = var.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.cf_landscape_label.output
  parameters = jsonencode({
    instance_name = local.subaccount_cf_org
  })
}

# # ------------------------------------------------------------------------------------------------------
# # Create app subscription to SAP Business APplication Studio
# # ------------------------------------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
}

# Create app subscription to busineass applicaiton stuido
resource "btp_subaccount_subscription" "bas" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Business_Application_Studio_Developer"
  origin               = local.origin_key_app_users
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "bas_admn" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud tools
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__hana_cloud_tools
  plan_name     = "tools"
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__hana_cloud_tools
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin" {
  for_each             = toset(var.hana_cloud_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  origin               = local.origin_key_app_users
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "hana-cloud"
  plan_name     = "hana"
}

# Get plan for SAP HANA Cloud
data "btp_subaccount_service_plan" "hana_cloud" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  offering_name = "hana-cloud"
  name          = "hana"
  depends_on    = [btp_subaccount_entitlement.hana_cloud]
}

# resource "btp_subaccount_service_instance" "hana_cloud" {
#   subaccount_id  = data.btp_subaccount.dc_mission.id
#   serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
#   name           = "my-hana-cloud-instance"
#   depends_on     = [btp_subaccount_entitlement.hana_cloud]
#   parameters = jsonencode(
#     {
#       "data" : {
#         "memory" : 32,
#         "edition" : "cloud",
#         "systempassword" : "${var.hana_system_password}",
#         "additionalWorkers" : 0,
#         "disasterRecoveryMode" : "no_disaster_recovery",
#         "enabledservices" : {
#           "docstore" : false,
#           "dpserver" : true,
#           "scriptserver" : false
#         },
#         "requestedOperation" : {},
#         "serviceStopped" : false,
#         "slaLevel" : "standard",
#         "storage" : 120,
#         "vcpu" : 2,
#         "whitelistIPs" : ["0.0.0.0/0"]
#       }
#   })

#   timeouts = {
#     create = "45m"
#     update = "45m"
#     delete = "45m"
#   }
# }

# # Create service binding to SAP HANA Cloud service 
# resource "btp_subaccount_service_binding" "hana_cloud" {
#   subaccount_id       = data.btp_subaccount.dc_mission.id
#   service_instance_id = btp_subaccount_service_instance.hana_cloud.id
#   name                = "hana-cloud-key"
# }

# # ------------------------------------------------------------------------------------------------------
# # Create app subscription to SAP Build Process Automation 
# # ------------------------------------------------------------------------------------------------------

resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}

# Create app subscription to SAP Build Process Automation (depends on entitlement)
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationAdmin"
  origin               = local.origin_key_app_users
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationDeveloper"
  origin               = local.origin_key_app_users
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_participants)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "ProcessAutomationParticipant"
  origin               = local.origin_key_app_users
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Event Mesh
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "event_mesh" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "enterprise-messaging"
  plan_name     = "default"
}

resource "btp_subaccount_entitlement" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = "enterprise-messaging-hub"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = "enterprise-messaging-hub"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.event_mesh_application]
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_admin" {
  depends_on           = [btp_subaccount_subscription.event_mesh_application]
  for_each             = toset(var.event_mesh_admins)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Enterprise Messaging Administrator"
  origin               = local.origin_key_app_users
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_developer" {
  depends_on           = [btp_subaccount_subscription.event_mesh_application]
  for_each             = toset(var.event_mesh_developers)
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Enterprise Messaging Developer"
  origin               = local.origin_key_app_users
  user_name            = each.value
}


# ------------------------------------------------------------------------------------------------------
# Create tfvars file for step 2 (if variable `create_tfvars_file_for_step2` is set to true)
# ------------------------------------------------------------------------------------------------------
resource "local_file" "output_vars_step1" {
  count    = var.create_tfvars_file_for_step2 ? 1 : 0
  content  = <<-EOT
      globalaccount        = "${var.globalaccount}"
      cli_server_url       = ${jsonencode(var.cli_server_url)}
      custom_idp           = ${jsonencode(var.custom_idp)}

      subaccount_id        = "${data.btp_subaccount.dc_mission.id}"

      cf_api_url           = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["API Endpoint"]}"

      cf_org_id            = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org ID"]}"
      cf_org_name          = "${jsondecode(btp_subaccount_environment_instance.cloudfoundry.labels)["Org Name"]}"

      cf_space_name        = "${var.cf_space_name}"

      cf_org_users         = ${jsonencode(var.cf_org_users)}
      cf_org_admins        = ${jsonencode(var.cf_org_admins)}
      cf_space_developers  = ${jsonencode(var.cf_space_developers)}
      cf_space_managers    = ${jsonencode(var.cf_space_managers)}


      EOT
  filename = "../step2/terraform.tfvars"
}