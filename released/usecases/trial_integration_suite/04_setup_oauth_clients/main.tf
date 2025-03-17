/*
After enablement of the capabilites, we have
- additional entitlements to assigne to the directory and the subaccount
- additional role collections to assign to the users
- Creation of service instances for OAuth Clients
- Creation of service bindings for the OAuth Clients
*/

locals {
  it_if_plan          = "integration-flow"
  it_api_plan         = "api"
  it_service          = "it-rt"
  it_if_binding_name  = "integration-flow-oauthclient-binding"
  it_api_binding_name = "api-oauthclient-binding"
}

resource "btp_subaccount_role_collection_assignment" "pi_admins" {
  for_each             = toset(var.pi_admins)
  subaccount_id        = var.subaccount_id
  role_collection_name = "PI_Administrator"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "pi_business_experts" {
  for_each             = toset(var.pi_business_experts)
  subaccount_id        = var.subaccount_id
  role_collection_name = "PI_Business_Expert"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "pi_int_dev" {
  for_each             = toset(var.pi_integration_developers)
  subaccount_id        = var.subaccount_id
  role_collection_name = "PI_Integration_Developer"
  user_name            = each.value
}

resource "btp_subaccount_role_collection_assignment" "pi_readonly" {
  for_each             = toset(var.pi_readonly)
  subaccount_id        = var.subaccount_id
  role_collection_name = "PI_Read_Only"
  user_name            = each.value
}

resource "btp_directory_entitlement" "dir_pi_if_entitlement" {
  directory_id = var.directory_id
  service_name = local.it_service
  plan_name    = local.it_if_plan
  distribute   = false
  auto_assign  = false
}

resource "btp_directory_entitlement" "dir_pi_api_entitlement" {
  directory_id = var.directory_id
  service_name = local.it_service
  plan_name    = local.it_api_plan
  distribute   = false
  auto_assign  = false
}

resource "btp_subaccount_entitlement" "subaccount_pi_if_entitlement" {
  subaccount_id = var.subaccount_id
  service_name  = local.it_service
  plan_name     = local.it_if_plan
  depends_on    = [btp_directory_entitlement.dir_pi_if_entitlement]
}

resource "btp_subaccount_entitlement" "subaccount_pi_api_entitlement" {
  subaccount_id = var.subaccount_id
  service_name  = local.it_service
  plan_name     = local.it_api_plan
  depends_on    = [btp_directory_entitlement.dir_pi_api_entitlement]
}

//We need to wait until the entitlements are propagated to the CF marketplace to create service instances
resource "time_sleep" "wait_30_seconds" {
  depends_on = [btp_subaccount_entitlement.subaccount_pi_api_entitlement, btp_subaccount_entitlement.subaccount_pi_if_entitlement]

  create_duration = "30s"
}

data "cloudfoundry_service_plans" "integration_flow" {
  name                  = local.it_if_plan
  service_offering_name = local.it_service
  depends_on            = [wait_30_seconds]
}

resource "cloudfoundry_service_instance" "integration_flow" {
  name         = "integration-flow-oauthclient"
  type         = "managed"
  space        = var.space_id
  service_plan = data.cloudfoundry_service_plans.integration_flow.service_plans[0].id
  parameters   = <<EOT
  {
    "roles": [
        "ESBMessaging.send"
    ],
    "grant-types": [
        "client_credentials"
    ],
    "redirect-uris": [],
    "token-validity": 3600
}
EOT
}

resource "cloudfoundry_service_credential_binding" "integration_flow_binding" {
  type             = "key"
  name             = local.it_if_binding_name
  service_instance = cloudfoundry_service_instance.integration_flow.id
}

data "cloudfoundry_service_plans" "it_api" {
  name                  = local.it_api_plan
  service_offering_name = local.it_service
  //depends_on            = [wait_30_seconds]
}

resource "cloudfoundry_service_instance" "it_api" {
  name         = "api-oauthclient"
  type         = "managed"
  space        = var.space_id
  service_plan = data.cloudfoundry_service_plans.it_api.service_plans[0].id
  parameters   = <<EOT
  {
    "roles": [
        "AccessAllAccessPoliciesArtifacts"
    ],
    "grant-types": [
        "client_credentials"
    ],
    "redirect-uris": [],
    "token-validity": 43200
}
EOT
}

resource "cloudfoundry_service_credential_binding" "api_binding" {
  type             = "key"
  name             = local.it_api_binding_name
  service_instance = cloudfoundry_service_instance.it_api.id
}

// The details of the binding cannot be fetched due to error "This service does not support fetching service binding parameters.."
/*data "cloudfoundry_service_credential_binding" "integration_flow_binding_data" {
  service_instance = cloudfoundry_service_instance.integration_flow.id
  name             = local.it_if_binding_name
  depends_on       = [cloudfoundry_service_credential_binding.integration_flow_binding]
}

data "cloudfoundry_service_credential_binding" "api_binding_data" {
  service_instance = cloudfoundry_service_instance.it_api.id
  name             = local.it_api_binding_name
  depends_on       = [cloudfoundry_service_credential_binding.api_binding]
}
*/
