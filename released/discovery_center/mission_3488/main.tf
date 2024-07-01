# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 3488
# ------------------------------------------------------------------------------------------------------
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = lower(replace("mission-3488-${local.random_uuid}", "_", "-"))
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Assign custom IDP to sub account (if custom_idp is set)
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_trust_configuration" "fully_customized" {
  # Only create trust configuration if custom_idp has been set 
  count             = var.custom_idp == "" ? 0 : 1
  subaccount_id     = btp_subaccount.dc_mission.id
  identity_provider = var.custom_idp
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
# Setup analytics-planning-osb
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "sac" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "analytics-planning-osb"
  plan_name     = "production"
}

data "btp_subaccount_service_plan" "sac" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = "analytics-planning-osb"
  name          = "production"
  depends_on    = [btp_subaccount_entitlement.sac]
}


resource "btp_subaccount_service_instance" "sac" {
  subaccount_id  = btp_subaccount.dc_mission.id
  name           = "service_analytics-planning-osb"
  serviceplan_id = data.btp_subaccount_service_plan.sac.id
  parameters = jsonencode(
    {
      "first_name" : "${var.sac_first_name}",
      "last_name" : "${var.sac_last_name}",
      "email" : "${var.sac_email}",
      "host_name" : "${var.sac_host_name}",
    }
  )
  depends_on = [btp_subaccount_entitlement.sac]
}


# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Assign role collection "Subaccount Administrator"
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_admin" {
  for_each             = toset("${var.subaccount_admins}")
  subaccount_id        = btp_subaccount.dc_mission.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount.dc_mission]
}
