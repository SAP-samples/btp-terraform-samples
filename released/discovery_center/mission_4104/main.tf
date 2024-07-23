# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 4104
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "subaccount_domain_suffix" {}

locals {
  random_uuid          = random_uuid.subaccount_domain_suffix.result
  subaccount_subdomain = lower(replace("dcmission-4104-${local.random_uuid}", "_", "-"))
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  name      = var.subaccount_name
  subdomain = local.subaccount_subdomain
  region    = lower(var.region)
}


# ------------------------------------------------------------------------------------------------------
# SERVICES
# ------------------------------------------------------------------------------------------------------
# ------------------------------------------------------------------------------------------------------
# Setup data-analytics-osb (not running in CF environment)
# ------------------------------------------------------------------------------------------------------
# Entitle 
resource "btp_subaccount_entitlement" "datasphere" {
  subaccount_id = btp_subaccount.dc_mission.id
  service_name  = "data-analytics-osb"
  plan_name     = "standard"
}
# Get serviceplan_id for data-analytics-osb with plan_name "standard"
data "btp_subaccount_service_plan" "datasphere" {
  subaccount_id = btp_subaccount.dc_mission.id
  offering_name = "data-analytics-osb"
  name          = "standard"
  depends_on    = [btp_subaccount_entitlement.datasphere]
}

# Create service instance
resource "btp_subaccount_service_instance" "datasphere" {
  subaccount_id  = btp_subaccount.dc_mission.id
  serviceplan_id = data.btp_subaccount_service_plan.datasphere.id
  name           = "standard_datasphere-service"
  parameters = jsonencode(
    {
      "first_name" : "${var.datasphere_first_name}",
      "last_name" : "${var.datasphere_last_name}",
      "email" : "${var.datasphere_email}",
      "host_name" : "${var.datasphere_host_name}",
    }
  )
  timeouts = {
    create = "90m"
    update = "90m"
    delete = "90m"
  }
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
