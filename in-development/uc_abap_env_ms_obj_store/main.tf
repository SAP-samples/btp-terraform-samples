# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain and the CF org (to ensure uniqueness in BTP global account)
# ------------------------------------------------------------------------------------------------------
locals {
  random_uuid               = uuid()
  project_subaccount_domain = "abapenv${local.random_uuid}"
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""), 0, 32)
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

# ------------------------------------------------------------------------------------------------------
# Assignment of emergency admins to the sub account as sub account administrators
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_role_collection_assignment" "subaccount_users" {
  for_each             = toset("${var.emergency_admins}")
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}

# ------------------------------------------------------------------------------------------------------
# Prepare and setup SAP BTP, ABAP environment
# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage
resource "btp_subaccount_entitlement" "sap_abap_env" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "abap"
  plan_name     = "free"
  amount        = 1
}

# Get plan for SAP BTP, ABAP environment
data "btp_subaccount_service_plan" "sap_abap_env" {
  subaccount_id = var.subaccount_id
  name          = "free"
  offering_name = "abap"
  depends_on    = [btp_subaccount_entitlement.sap_abap_env]
}

# Create service instance for SAP BTP, ABAP environment
resource "btp_subaccount_service_instance" "sap_abap_env" {
  subaccount_id  = btp_subaccount.project.id
  serviceplan_id = data.btp_subaccount_service_plan.sap_abap_env.id
  name           = "my-abap-environment"

  parameters = jsonencode({
    admin_email   = "john.doe@test.com"
    description   = "Main development system"
    sapsystemname = "H01"
  })

  depends_on = [btp_subaccount_entitlement.sap_abap_env]
}

# Create service binding to ABAP service
resource "btp_subaccount_service_binding" "my_abap_env_binding" {
  subaccount_id       = btp_subaccount.project.id
  service_instance_id = btp_subaccount_service_instance.sap_abap_env.id
  name                = "ADT"
}


# ------------------------------------------------------------------------------------------------------
# Entitle subaccount for usage of abapcp-web-router
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount_entitlement" "abapcp-web-router" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "abapcp-web-router"
  plan_name     = "default"
}

# Create app subscription to abapcp-web-router
resource "btp_subaccount_subscription" "abapcp-web-router" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "abapcp-web-router"
  plan_name     = "default"
  depends_on    = [btp_subaccount_entitlement.abapcp-web-router]
}

# ------------------------------------------------------------------------------------------------------
# Add Azure storage container on Azure
# ------------------------------------------------------------------------------------------------------
module "azure_storage" {
  source               = "../modules/azure_storage"
  rg_name              = var.azure_rg_name
  location             = var.azure_location
  storage_account_name = var.azure_storage_account_name
  container_name       = var.azure_container_name
}
