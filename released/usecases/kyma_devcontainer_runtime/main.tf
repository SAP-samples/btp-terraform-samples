resource "random_id" "devcontainer_runtime" {
  byte_length = 8
}

resource "btp_subaccount" "devcontainer_runtime" {
  name      = var.subaccount_name
  subdomain = var.subaccount_subdomain == "devcontainer-runtime" ? "devcontainer-runtime-${random_id.devcontainer_runtime.hex}" : var.subaccount_subdomain
  region    = var.region
}

resource "btp_subaccount_entitlement" "kyma_trial" {
  subaccount_id = btp_subaccount.devcontainer_runtime.id
  service_name  = "kymaruntime"
  plan_name     = "trial"
  amount        = 1
}

module "kyma_runtime" {
  source         = "../../modules/environment/kyma/envinstance_kyma"
  subaccount_id  = btp_subaccount.devcontainer_runtime.id
  name           = "private-codespaces"
  plan           = "trial"
  administrators = var.users

  depends_on = [btp_subaccount_entitlement.kyma_trial]
}

data "btp_whoami" "me" {}

resource "null_resource" "devpod" {
  provisioner "local-exec" {
    when    = create
    command = "devpod provider add kubernetes --name sap-btp --option KUBERNETES_NAMESPACE= --option KUBERNETES_CONFIG=${abspath(path.root)}/${module.kyma_runtime.kubeconfig}"
  }

  provisioner "local-exec" {
    when    = destroy
    command = "devpod provider delete sap-btp"
  }
}
