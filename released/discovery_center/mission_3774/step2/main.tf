# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = var.cf_space_name
  org  = var.cf_org_id #
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
  origin   = var.custom_idp
}
# Define Org Manager role
resource "cloudfoundry_org_role" "organization_manager" {
  for_each   = toset("${var.cf_org_admins}")
  username   = each.value
  type       = "organization_manager"
  org        = var.cf_org_id
  origin     = var.custom_idp
  depends_on = [cloudfoundry_org_role.organization_user]
}

# ------------------------------------------------------------------------------------------------------
# Assign CF space roles to the users
# ------------------------------------------------------------------------------------------------------
# Define Space Manager role
resource "cloudfoundry_space_role" "space_managers" {
  for_each   = toset(var.cf_space_managers)
  username   = each.value
  type       = "space_manager"
  space      = cloudfoundry_space.space.id
  origin     = var.custom_idp
  depends_on = [cloudfoundry_org_role.organization_manager]
}
# Define Space Developer role
resource "cloudfoundry_space_role" "space_developers" {
  for_each   = toset(var.cf_space_developers)
  username   = each.value
  type       = "space_developer"
  space      = cloudfoundry_space.space.id
  origin     = var.custom_idp
  depends_on = [cloudfoundry_org_role.organization_manager]
}

# ------------------------------------------------------------------------------------------------------
# Create service instance for taskcenter (one-inbox-service)
# ------------------------------------------------------------------------------------------------------
data "cloudfoundry_service" "srvc_taskcenter" {
  name = "one-inbox-service"
}

resource "cloudfoundry_service_instance" "si_taskcenter" {
  name         = "sap-taskcenter"
  type         = "managed"
  space        = cloudfoundry_space.space.id
  service_plan = data.cloudfoundry_service.srvc_taskcenter.service_plans["standard"]
  depends_on   = [cloudfoundry_space_role.space_managers, cloudfoundry_space_role.space_developers]
  parameters = jsonencode({
    "authorities" : [],
    "defaultCollectionQueryFilter" : "own"
  })
}

# ------------------------------------------------------------------------------------------------------
# Create service key
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "service_key_stc" {}

resource "cloudfoundry_service_credential_binding" "sap-taskcenter" {
  type             = "key"
  name             = join("_", ["defaultKey", random_uuid.service_key_stc.result])
  service_instance = cloudfoundry_service_instance.si_taskcenter.id
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup service: destination
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of service destination
resource "btp_subaccount_entitlement" "destination" {
  subaccount_id = var.subaccount_id
  service_name  = "destination"
  plan_name     = "lite"
}
# Get serviceplan_id for stc-service with plan_name "default"
data "btp_subaccount_service_plan" "destination" {
  subaccount_id = var.subaccount_id
  offering_name = "destination"
  name          = "lite"
  depends_on    = [btp_subaccount_entitlement.destination]
}
# Create service instance
resource "btp_subaccount_service_instance" "destination" {
  subaccount_id  = var.subaccount_id
  serviceplan_id = data.btp_subaccount_service_plan.destination.id
  name           = "destination"
  depends_on     = [data.btp_subaccount_service_plan.destination]
  parameters = jsonencode({
    HTML5Runtime_enabled = true
    init_data = {
      subaccount = {
        existing_destinations_policy = "update"
        destinations = [
          {
            Description = "[Do not delete] SAP Task Center - Dummy destination"
            Type        = "HTTP"
            #            clientId                   = "${jsondecode(cloudfoundry_service_credential_binding.sap-taskcenter)["uaa"]["clientid"]}"
            #            clientSecret               = "${jsondecode(cloudfoundry_service_credential_binding.sap-taskcenter)["uaa"]["clientsecret"]}"
            "HTML5.DynamicDestination" = true
            Authentication             = "OAuth2JWTBearer"
            Name                       = "stc-destination"
            #            tokenServiceURL            = "${jsondecode(cloudfoundry_service_credential_binding.sap-taskcenter)["uaa"]["url"]}"
            ProxyType = "Internet"
            #            URL                        = "${jsondecode(cloudfoundry_service_credential_binding.sap-taskcenter.credentials)["url"]}"
            tokenServiceURLType = "Dedicated"
          }
        ]
      }
    }
  })
}