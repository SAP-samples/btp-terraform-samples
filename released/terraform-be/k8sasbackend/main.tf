###############################################################################################
# Creation of subaccount
###############################################################################################
resource "random_uuid" "uuid" {}

resource "btp_subaccount" "project" {
  name      = var.subaccount_name
  subdomain = "${var.subaccount_name}-${random_uuid.uuid.result}"
  region    = lower(var.region)
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
