###############################################################################################
# Setup subaccount domain and the CF org (to ensure uniqueness in BTP global account)
###############################################################################################
locals {
  project_subaccount_domain = lower("${var.subaccount_name}-${var.org}")
  project_subaccount_cf_org = substr(replace("${local.project_subaccount_domain}", "-", ""),0,32)
}

 
###############################################################################################
# Creation of subaccount
###############################################################################################
resource "btp_subaccount" "create_subaccount" {
  count = var.subaccount_id == "" ? 1 : 0

  name      = var.subaccount_name
  subdomain = local.project_subaccount_domain
  region    = lower(var.region)
}

data "btp_subaccount" "project" {
  id = var.subaccount_id != "" ? var.subaccount_id : btp_subaccount.create_subaccount[0].id
}
 

data "btp_subaccount_environments" "all" {
  subaccount_id = data.btp_subaccount.project.id
}

 
###############################################################################################
# Assign custom IDP to sub account
###############################################################################################
resource "btp_subaccount_trust_configuration" "fully_customized" {
  count = var.custom_idp == "" ? 0 : 1
  subaccount_id = data.btp_subaccount.project.id
  identity_provider = var.custom_idp 
}
 

###############################################################################################
# Creation of Cloud Foundry environment
###############################################################################################


# ------------------------------------------------------------------------------------------------------
# Take the landscape label from the first CF environment if no environment label is provided
# ------------------------------------------------------------------------------------------------------
resource "null_resource" "cache_target_environment" {
  triggers = {
    label = length(var.environment_label) > 0 ? var.environment_label : [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
  }

  lifecycle {
    ignore_changes = all
  }
}

resource "btp_subaccount_environment_instance" "cf" {
  subaccount_id    = data.btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = null_resource.cache_target_environment.triggers.label

  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
 }

resource "cloudfoundry_org_role" "manager" {
  for_each = toset(var.admins)
  username = each.value
  type     = "organization_manager"
  org      = btp_subaccount_environment_instance.cf.platform_id
  origin  = var.origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}

resource "cloudfoundry_org_role" "user" {
  for_each = toset(var.developers)
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cf.platform_id
  #origin = btp_subaccount_trust_configuration.simple.origin
  origin  = var.origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}
resource "cloudfoundry_org_role" "user_admins" {
  for_each = toset(var.admins)
  username = each.value
  type     = "organization_user"
  org      = btp_subaccount_environment_instance.cf.platform_id
  #origin = btp_subaccount_trust_configuration.simple.origin
  origin  = var.origin
  depends_on = [ btp_subaccount_environment_instance.cf ]
}

 
###############################################################################################
# Prepare and setup app: SAP Build Workzone, standard edition
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Build Workzone, standard edition
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = var.build_workzone_service_plan 
}
 
# Create app subscription to SAP Build Workzone, standard edition (depends on entitlement)
resource "btp_subaccount_subscription" "build_workzone" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = var.build_workzone_service_plan
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}
 

###############################################################################################
# Prepare and setup app: SAP Business Application Studio
###############################################################################################
# Entitle subaccount for usage of app  destination SAP Business Application Studio
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  service_name = "sapappstudio"
  plan_name = var.bas_service_plan
}

# Create app subscription to SAP Business Application Studio (depends on entitlement)
resource "btp_subaccount_subscription" "bas" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "sapappstudio"
  plan_name     = var.bas_service_plan
  depends_on    = [btp_subaccount_entitlement.bas]
}



###############################################################################################
# Prepare and setup app: Continous Integration & Delivery
###############################################################################################
# Entitle subaccount for usage of app  destination Continous Integration & Delivery
resource "btp_subaccount_entitlement" "cicd" {
  subaccount_id = data.btp_subaccount.project.id
  service_name = "cicd-app"
  plan_name = var.cicd_service_plan
}

# Create app subscription to SAP Business Application Studio (depends on entitlement)
resource "btp_subaccount_subscription" "cicd" {
  subaccount_id = data.btp_subaccount.project.id
  app_name      = "cicd-app"
  plan_name     = var.cicd_service_plan
  depends_on    = [btp_subaccount_entitlement.cicd]
}



###############################################################################################
# Assign User to role collections
###############################################################################################
# Assignment of admins to the sub account as sub account administrators
resource "btp_subaccount_role_collection_assignment" "subaccount_admins" {
  for_each = toset("${var.admins}")
  subaccount_id         = data.btp_subaccount.project.id
  role_collection_name  = "Subaccount Administrator"
  user_name             = each.value
}

# Assignment of developers to the sub account as sub account views
resource "btp_subaccount_role_collection_assignment" "subaccount_viewer" {
  for_each = toset("${var.admins}")
  subaccount_id         = data.btp_subaccount.project.id
  role_collection_name  = "Subaccount Viewer"
  user_name             = each.value
}
# Assign users to Role Collection: Launchpad_Admin
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  for_each = toset("${var.admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.build_workzone]
}

# Assign users to Role Collection: Business_Application_Studio_Administrator
resource "btp_subaccount_role_collection_assignment" "bas_admin" {
  for_each = toset("${var.admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}

# Assign users to Role Collection: Business_Application_Studio_Developer
resource "btp_subaccount_role_collection_assignment" "bas_dev" {
  for_each = toset("${var.developers}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.bas]
}


# Assign users to Role Collection: CICD Service Administrator
resource "btp_subaccount_role_collection_assignment" "cicd_admin" {
  for_each = toset("${var.admins}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Administrator"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd]
}

# Assign users to Role Collection: CICD Service Developer
resource "btp_subaccount_role_collection_assignment" "cicd_dev" {
  for_each = toset("${var.developers}")
  subaccount_id        = data.btp_subaccount.project.id
  role_collection_name = "CICD Service Developer"
  user_name            = each.value
  depends_on           = [btp_subaccount_subscription.cicd]
}

