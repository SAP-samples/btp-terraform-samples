# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    btp = {
      source = "SAP/btp"
      version = "0.6.0-beta2"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Execute the Kyma instance creation
# ------------------------------------------------------------------------------------------------------
locals {
  subaccount_iaas_provider = [for region in data.btp_regions.all.values : region if region.region == data.btp_subaccount.this.region][0].iaas_provider
}

data "btp_regions" "all" {}

data "btp_subaccount" "this" {
  id = var.subaccount_id
}

resource "btp_subaccount_entitlement" "kymaruntime" {
  subaccount_id = var.subaccount_id

  service_name = "kymaruntime"
  plan_name    = var.plan != null ? var.plan : lower(local.subaccount_iaas_provider)
  amount       = 1
}

data "btp_whoami" "me" {}

resource "btp_subaccount_environment_instance" "kymaruntime" {
  subaccount_id = var.subaccount_id

  name             = var.name
  environment_type = "kyma"
  service_name     = btp_subaccount_entitlement.kymaruntime.service_name
  plan_name        = btp_subaccount_entitlement.kymaruntime.plan_name

  parameters = jsonencode(merge({
    name           = var.name
    administrators = toset(concat(tolist(var.administrators), [data.btp_whoami.me.email]))
    }, var.oidc == null ? null : {
    issuerURL      = var.oidc.issuer_url
    clientID       = var.oidc.client_id
    groupsClaim    = var.oidc.groups_claim
    usernameClaim  = var.oidc.username_claim
    usernamePrefix = var.oidc.username_prefix
    signingAlgs    = var.oidc.signing_algs
  }))

  depends_on = [btp_subaccount_entitlement.kymaruntime]
}

data "http" "kubeconfig" {
  url = jsondecode(btp_subaccount_environment_instance.kymaruntime.labels)["KubeconfigURL"]
}

resource "local_sensitive_file" "kubeconfig" {
  filename = ".${var.subaccount_id}-${var.name}.kubeconfig"
  content  = data.http.kubeconfig.response_body
}
