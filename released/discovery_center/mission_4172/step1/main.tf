###############################################################################################
# Setup of names in accordance to naming convention
###############################################################################################
resource "random_uuid" "uuid" {}

locals {
  random_uuid               = random_uuid.uuid.result
  project_subaccount_domain = lower(replace("mission-4172-${local.random_uuid}", "_", "-"))
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "project" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
  usage     = "USED_FOR_PRODUCTION"
}

data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.project[0].id
}

###############################################################################################
# Assignment of users as sub account administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-admins" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

###############################################################################################
# Assignment of users as sub account service administrators
###############################################################################################
resource "btp_subaccount_role_collection_assignment" "subaccount-service-admins" {
  for_each             = toset("${var.subaccount_service_admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Subaccount Service Administrator"
  user_name            = each.value
}

######################################################################
# Extract list of CF landscape labels from environments
######################################################################
data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.project.id
}

locals {
  cf_landscape_labels = [
    for env in data.btp_subaccount_environments.all.values : env.landscape_label
    if env.environment_type == "cloudfoundry"
  ]
}


######################################################################
# Creation of Cloud Foundry environment
######################################################################
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = data.btp_subaccount.project.id
  name             = var.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = local.cf_landscape_labels[0]
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
}

######################################################################
# Entitlement of all general services
######################################################################
resource "btp_subaccount_entitlement" "genentitlements" {
  for_each = {
    for index, entitlement in var.entitlements :
    index => entitlement
  }
  subaccount_id = data.btp_subaccount.project.id
  service_name  = each.value.service_name
  plan_name     = each.value.plan_name
}

# ######################################################################
# # Create app subscription to SAP Business APplication Studio
# ######################################################################

resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
}

# Create app subscription to busineass applicaiton stuido
resource "btp_subaccount_subscription" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service__sap_business_app_studio
  plan_name     = var.service_plan__sap_business_app_studio
  depends_on    = [btp_subaccount_entitlement.bas]
}

resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_developers)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "bas_admn" {
  depends_on           = [btp_subaccount_subscription.bas]
  for_each             = toset(var.appstudio_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
}

######################################################################
# Assign other Role Collection
######################################################################

resource "btp_subaccount_role_collection_assignment" "cloud_conn_admn" {
  depends_on           = [btp_subaccount_entitlement.genentitlements]
  for_each             = toset(var.cloudconnector_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Cloud Connector Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "conn_dest_admn" {
  depends_on           = [btp_subaccount_entitlement.genentitlements]
  for_each             = toset(var.conn_dest_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Connectivity and Destination Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud tools
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__hana_cloud_tools
  plan_name     = "tools"
}

resource "btp_subaccount_subscription" "hana_cloud_tools" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service_name__hana_cloud_tools
  plan_name     = "tools"
  depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin" {
  for_each             = toset(var.hana_cloud_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "SAP HANA Cloud Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
}

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
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

resource "btp_subaccount_service_instance" "hana_cloud" {
  subaccount_id  = data.btp_subaccount.project.id
  serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
  name           = "my-hana-cloud-instance"
  depends_on     = [btp_subaccount_entitlement.hana_cloud]
  parameters = jsonencode(
    {
      "data" : {
        "memory" : 32,
        "edition" : "cloud",
        "systempassword" : "${var.hana_system_password}",
        "additionalWorkers" : 0,
        "disasterRecoveryMode" : "no_disaster_recovery",
        "enabledservices" : {
          "docstore" : false,
          "dpserver" : true,
          "scriptserver" : false
        },
        "requestedOperation" : {},
        "serviceStopped" : false,
        "slaLevel" : "standard",
        "storage" : 120,
        "vcpu" : 2,
        "whitelistIPs" : ["0.0.0.0/0"]
      }
  })

  timeouts = {
    create = "45m"
    update = "45m"
    delete = "45m"
  }
}

# Create service binding to SAP HANA Cloud service 
resource "btp_subaccount_service_binding" "hana_cloud" {
  subaccount_id       = data.btp_subaccount.project.id
  service_instance_id = btp_subaccount_service_instance.hana_cloud.id
  name                = "hana-cloud-key"
}

# ######################################################################
# # Create app subscription to SAP Build Process Automation 
# ######################################################################

resource "btp_subaccount_entitlement" "build_process_automation" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
}

# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_process_automation" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = local.service_name__sap_process_automation
  plan_name     = var.service_plan__sap_process_automation
  depends_on    = [btp_subaccount_entitlement.build_process_automation]
}

resource "btp_subaccount_role_collection_assignment" "sbpa_admin" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationAdmin"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_dev" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_developers)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationDeveloper"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "sbpa_part" {
  depends_on           = [btp_subaccount_subscription.build_process_automation]
  for_each             = toset(var.process_automation_participants)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "ProcessAutomationParticipant"
  user_name            = each.value
}

######################################################################
# Event Mesh
######################################################################
resource "btp_subaccount_entitlement" "event_mesh" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "enterprise-messaging"
  plan_name     = "default"
}

resource "btp_subaccount_entitlement" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "enterprise-messaging-hub"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "event_mesh_application" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "enterprise-messaging-hub"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.event_mesh_application]
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_admin" {
  depends_on           = [btp_subaccount_entitlement.event_mesh_application]
  for_each             = toset(var.event_mesh_admins)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Enterprise Messaging Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "event_mesh_developer" {
  depends_on           = [btp_subaccount_entitlement.event_mesh_application]
  for_each             = toset(var.event_mesh_developers)
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Enterprise Messaging Developer"
  user_name            = each.value
}
