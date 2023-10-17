###############################################################################################
# create a subaccount in eu12 region
##############################################################################################
resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = var.subaccount_name
  region    = var.region
}
#########################################
# Add entitlement for Kymaruntime
#########################################
resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = "${btp_subaccount.project.id}"
  service_name = "kymaruntime"
  plan_name    = "aws"
  amount       = 1
}
data "btp_whoami" "me" {}
resource "btp_subaccount_environment_instance" "kymaruntime" {
  subaccount_id = "${btp_subaccount.project.id}"

  name             = "test-cluster"
  environment_type = "kyma"
  service_name     = "kymaruntime"
  plan_name        = "aws"

  parameters = jsonencode(merge({
    name           = "test-cluster"
    administrators = toset(concat(tolist(var.administrators), [data.btp_whoami.me.email]))
    }, var.oidc == null ? null : {
    issuerURL      = var.oidc.issuer_url
    clientID       = var.oidc.client_id
    groupsClaim    = var.oidc.groups_claim
    usernameClaim  = var.oidc.username_claim
    usernamePrefix = var.oidc.username_prefix
    signingAlgs    = var.oidc.signing_algs
  }))
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "1h"
  }
  depends_on = [btp_subaccount_entitlement.kymaruntime]
}

data "http" "kubeconfig" {
  url = jsondecode(btp_subaccount_environment_instance.kymaruntime.labels)["KubeconfigURL"]
}

resource "local_sensitive_file" "kubeconfig" {
  filename = ".{btp_subaccount.project.id}-$test-cluster.kubeconfig"
  content  = data.http.kubeconfig.response_body
}
######################################################################
# Add "sleep" resource for generic purposes
######################################################################
resource "time_sleep" "wait_a_few_seconds" {
  create_duration = "30s"
}

######################################################################
# Add entitlement for BAS, Subscribe BAS and add roles
######################################################################
resource "btp_subaccount_entitlement" "bas" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "sapappstudio"
  plan_name     = var.bas_plan_name
}
resource "btp_subaccount_subscription" "bas-subscribe" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "sapappstudio"
  plan_name     = var.bas_plan_name
  depends_on    = [btp_subaccount_entitlement.bas]
}
resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Administrator" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Administrator"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}
resource "btp_subaccount_role_collection_assignment" "Business_Application_Studio_Developer" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Business_Application_Studio_Developer"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.bas-subscribe]
}
######################################################################
# Add Build Workzone entitlement subscription and role Assignment
######################################################################
resource "btp_subaccount_entitlement" "build_workzone" {
  subaccount_id = btp_subaccount.project.id
  service_name  = "SAPLaunchpad"
  plan_name     = var.build_workzone_plan_name
}
resource "btp_subaccount_subscription" "build_workzone_subscribe" {
  subaccount_id = btp_subaccount.project.id
  app_name      = "SAPLaunchpad"
  plan_name     = var.build_workzone_plan_name
  depends_on    = [btp_subaccount_entitlement.build_workzone]
}
resource "btp_subaccount_role_collection_assignment" "launchpad_admin" {
  subaccount_id        = btp_subaccount.project.id
  role_collection_name = "Launchpad_Admin"
  user_name            = var.btp_user
  depends_on           = [btp_subaccount_subscription.build_workzone_subscribe]
}
######################################################################
# Create HANA entitlement subscription
######################################################################
resource "btp_subaccount_entitlement" "hana-cloud" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana-cloud"
  plan_name        = var.hana-cloud_plan_name
}
# Enable HANA Cloud Tools
resource "btp_subaccount_entitlement" "hana-cloud-tools" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana-cloud-tools"
  plan_name        = "tools"
}
resource "btp_subaccount_subscription" "hana-cloud-tools" {
  subaccount_id    = btp_subaccount.project.id
  app_name         = "hana-cloud-tools"
  plan_name        = "tools"
  depends_on       = [btp_subaccount_entitlement.hana-cloud-tools]
}
resource "btp_subaccount_entitlement" "hana-hdi-shared" {
  subaccount_id    = btp_subaccount.project.id
  service_name     = "hana"
  plan_name        = "hdi-shared"
}