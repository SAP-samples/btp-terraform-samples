# ------------------------------------------------------------------------------------------------------
# Subaccount setup for DC mission 4441 (trial)
# ------------------------------------------------------------------------------------------------------
# Setup subaccount domain (to ensure uniqueness in BTP global account)
resource "random_uuid" "uuid" {}

locals {
  random_uuid       = random_uuid.uuid.result
  subaccount_domain = "dcmission4441trial${local.random_uuid}"
}

# ------------------------------------------------------------------------------------------------------
# Creation of subaccount
# ------------------------------------------------------------------------------------------------------
resource "btp_subaccount" "dc_mission" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.subaccount_domain
  region    = var.region
}

data "btp_subaccount" "dc_mission" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.dc_mission[0].id
}


# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
locals {
  service_name__build_code = "build-code"
}
# ------------------------------------------------------------------------------------------------------
# Setup build-code (SAP Build Code)
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  service_name  = local.service_name__build_code
  plan_name     = var.service_plan__build_code
  amount        = 1
}
# Subscribe
resource "btp_subaccount_subscription" "build_code" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  app_name      = local.service_name__build_code
  plan_name     = var.service_plan__build_code
  depends_on    = [btp_subaccount_entitlement.build_code]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
locals {
  build_code_admins     = var.build_code_admins
  build_code_developers = var.build_code_developers
}

# Get all available subaccount roles
data "btp_subaccount_roles" "all" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  depends_on    = [btp_subaccount_subscription.build_code]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection for Build Code Administrator
# ------------------------------------------------------------------------------------------------------
# Assign roles to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection" "build_code_administrator" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "Build Code Administrator"
  description   = "The role collection for an administrator on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Administrator", "Administrator", "RegistryAdmin"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection_assignment" "build_code_administrator" {
  for_each             = toset("${var.build_code_admins}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Administrator"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Build Code Developer"
# ------------------------------------------------------------------------------------------------------
# Create role collection "Build Code Developer"  
resource "btp_subaccount_role_collection" "build_code_developer" {
  subaccount_id = data.btp_subaccount.dc_mission.id
  name          = "Build Code Developer"
  description   = "The role collection for a developer on SAP Build Code"

  roles = [
    for role in data.btp_subaccount_roles.all.values : {
      name                 = role.name
      role_template_app_id = role.app_id
      role_template_name   = role.role_template_name
    } if contains(["Business_Application_Studio_Developer", "RegistryDeveloper", "Business_Application_Studio_Extension_Deployer"], role.role_template_name)
  ]
}
# Assign users to the role collection "Build Code Developer"
resource "btp_subaccount_role_collection_assignment" "build_code_developer" {
  for_each             = toset("${var.build_code_developers}")
  subaccount_id        = data.btp_subaccount.dc_mission.id
  role_collection_name = "Build Code Developer"
  user_name            = each.value
  origin               = "sap.default"
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
}
