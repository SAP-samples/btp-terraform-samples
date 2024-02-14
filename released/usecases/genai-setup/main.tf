# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
# ------------------------------------------------------------------------------------------------------
locals {
  # Please be aware that the domain name must be unique within the BTP global account
  # The domain name is used to create the subaccount.
  # That's whay we are using a random UUID to ensure uniqueness.
  # But, you can also use a fixed domain name, if you are sure that it is unique.
  # ------------------------------------------------------------------------------------------------------
  # IMPORTANT: But this means as well, that running a terraform apply command twice, will result
  # in a destroy and recreation of the subaccount and all its resources!
  random_uuid               = uuid()
  project_subaccount_domain = "btpllm${local.random_uuid}"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "gen_ai" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Prepare & setup the SAP AI Core service (ensure your global account has the respective entitlements)
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP AI Core service
# ------------------------------------------------------------------------------------------------------
# Checkout https://github.com/SAP-samples/btp-service-metadata/blob/main/v0/developer/aicore.json for 
# available plans and their region availability 
resource "btp_subaccount_entitlement" "ai_core" {
  subaccount_id = btp_subaccount.gen_ai.id
  service_name  = "aicore"
  plan_name     = var.ai_core_plan_name
}

# Get plan for SAP AI Core service
data "btp_subaccount_service_plan" "ai_core" {
  subaccount_id = btp_subaccount.gen_ai.id
  offering_name = "aicore"
  name          = var.ai_core_plan_name
  depends_on    = [btp_subaccount_entitlement.ai_core]  
}

# Create service instance for SAP AI Core service
resource "btp_subaccount_service_instance" "ai_core"{
  subaccount_id = btp_subaccount.gen_ai.id
  serviceplan_id = data.btp_subaccount_service_plan.ai_core.id
  name           = "my-ai-core-instance"
  depends_on    = [btp_subaccount_entitlement.ai_core]
}

# Create service binding to SAP AI Core service (exposed for a specific user group)
resource "btp_subaccount_service_binding" "ai_core_binding" {
  subaccount_id = btp_subaccount.gen_ai.id
  service_instance_id = btp_subaccount_service_instance.ai_core.id
  name                = "ai-core-key"
}

# ------------------------------------------------------------------------------------------------------
# Prepare & setup SAP AI Launchpad
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "ai_launchpad" {
  subaccount_id = btp_subaccount.gen_ai.id
  service_name  = "ai-launchpad"
  plan_name     = "standard"
}

resource "btp_subaccount_subscription" "ai_launchpad" {
  subaccount_id = btp_subaccount.gen_ai.id
  app_name      = "ai-launchpad"
  plan_name     = "standard"
  depends_on    = [btp_subaccount_entitlement.ai_launchpad]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "ai_launchpad_admin" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.gen_ai.id
  role_collection_name = "ailaunchpad_genai_administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "ailaunchpad_aicore_admin_editor" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.gen_ai.id
  role_collection_name = "ailaunchpad_aicore_admin_editor"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "ailaunchpad_allow_all_resourcegroups" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.gen_ai.id
  role_collection_name = "ailaunchpad_allow_all_resourcegroups"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

# Assign users to Role Collection: SAP HANA Cloud Administrator
resource "btp_subaccount_role_collection_assignment" "connections_editor" {
  for_each             = toset("${var.admins}")
  subaccount_id        = btp_subaccount.gen_ai.id
  role_collection_name = "connections_editor"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.ai_launchpad]
}

# ------------------------------------------------------------------------------------------------------
# Prepare & setup SAP HANA Cloud for usage of Vector Engine
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud tools
# ------------------------------------------------------------------------------------------------------
# resource "btp_subaccount_entitlement" "hana_cloud_tools" {
#   subaccount_id = btp_subaccount.gen_ai.id
#   service_name  = "hana-cloud-tools"
#   plan_name     = "tools"
# }

# resource "btp_subaccount_subscription" "hana_cloud_tools" {
#   subaccount_id = btp_subaccount.gen_ai.id
#   app_name      = "hana-cloud-tools"
#   plan_name     = "tools"
#   depends_on    = [btp_subaccount_entitlement.hana_cloud_tools]
# }

# # Assign users to Role Collection: SAP HANA Cloud Administrator
# resource "btp_subaccount_role_collection_assignment" "hana_cloud_admin" {
#   for_each             = toset("${var.admins}")
#   subaccount_id        = btp_subaccount.gen_ai.id
#   role_collection_name = "SAP HANA Cloud Administrator"
#   user_name            = each.value
#   depends_on           = [btp_subaccount_subscription.hana_cloud_tools]
# }

# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of SAP HANA Cloud
# ------------------------------------------------------------------------------------------------------
# resource "btp_subaccount_entitlement" "hana_cloud" {
#   subaccount_id = btp_subaccount.gen_ai.id
#   service_name  = "hana-cloud"
#   plan_name     = "hana"
# }

# # Get plan for SAP HANA Cloud
# data "btp_subaccount_service_plan" "hana_cloud" {
#   subaccount_id = btp_subaccount.gen_ai.id
#   offering_name = "hana-cloud"
#   name          = "hana"
#   depends_on    = [btp_subaccount_entitlement.hana_cloud]  
# }

# # Create service instance for SAP HANA Cloud
# resource "btp_subaccount_service_instance" "hana_cloud"{
#   subaccount_id = btp_subaccount.gen_ai.id
#   serviceplan_id = data.btp_subaccount_service_plan.hana_cloud.id
#   name           = "my-hana-cloud-instance"
#   depends_on    = [btp_subaccount_entitlement.hana_cloud]
#   parameters    = jsonencode(
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
# }


# # Create service binding to SAP AI Core service (exposed for a specific user group)
# resource "btp_subaccount_service_binding" "hana_cloud" {
#   subaccount_id = btp_subaccount.gen_ai.id
#   service_instance_id = btp_subaccount_service_instance.hana_cloud.id
#   name                = "hana-cloud-key"
# }

