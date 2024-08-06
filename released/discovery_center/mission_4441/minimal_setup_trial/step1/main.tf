# ------------------------------------------------------------------------------------------------------
# SUBACCOUNT SETUP
# ------------------------------------------------------------------------------------------------------
data "btp_subaccounts" "all" {}

resource "terraform_data" "dc_mission_subaccount" {
  input = [for subaccount in data.btp_subaccounts.all.values : subaccount if subaccount.name == "trial"][0]
}

# ------------------------------------------------------------------------------------------------------
# APP SUBSCRIPTIONS
# ------------------------------------------------------------------------------------------------------
#
# ------------------------------------------------------------------------------------------------------
# Setup build-code
# ------------------------------------------------------------------------------------------------------
# Entitle
resource "btp_subaccount_entitlement" "build_code" {
  subaccount_id = terraform_data.dc_mission_subaccount.output.id
  service_name  = "build-code"
  plan_name     = "free"
  amount        = 1
}
# Subscribe
resource "btp_subaccount_subscription" "build_code" {
  subaccount_id = terraform_data.dc_mission_subaccount.output.id
  app_name      = "build-code"
  plan_name     = "free"
  depends_on    = [btp_subaccount_entitlement.build_code]
}

# ------------------------------------------------------------------------------------------------------
#  USERS AND ROLES
# ------------------------------------------------------------------------------------------------------
#
# Get all available subaccount roles
data "btp_subaccount_roles" "all" {
  subaccount_id = terraform_data.dc_mission_subaccount.output.id
  depends_on    = [btp_subaccount_subscription.build_code]
}
# ------------------------------------------------------------------------------------------------------
# Assign role collection for Build Code Administrator
# ------------------------------------------------------------------------------------------------------
# Assign roles to the role collection "Build Code Administrator"
resource "btp_subaccount_role_collection" "build_code_administrator" {
  subaccount_id = terraform_data.dc_mission_subaccount.output.id
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
  subaccount_id        = terraform_data.dc_mission_subaccount.output.id
  role_collection_name = "Build Code Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_administrator]
}

# ------------------------------------------------------------------------------------------------------
# Assign role collection "Build Code Developer"
# ------------------------------------------------------------------------------------------------------
# Create role collection "Build Code Developer"  
resource "btp_subaccount_role_collection" "build_code_developer" {
  subaccount_id = terraform_data.dc_mission_subaccount.output.id
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
  subaccount_id        = terraform_data.dc_mission_subaccount.output.id
  role_collection_name = "Build Code Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_role_collection.build_code_developer]
}
