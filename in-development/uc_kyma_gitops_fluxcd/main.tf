resource "btp_subaccount" "kyma_gitops" {
  name      = "kyma-gitops"
  subdomain = "kyma-gitops"
  region    = var.region
}

module "k8s_runtime" {
  source = "github.com/SAP-samples/btp-terraform-samples/released/modules/envinstance-kyma"

  subaccount_id = btp_subaccount.kyma_gitops.id

  name           = var.cluster_name
  administrators = var.developers
  plan           = "trial"
}

resource "flux_bootstrap_git" "this" {
  path = "clusters/${var.cluster_name}"

  kustomization_override = local.kustomization

  depends_on = [module.k8s_runtime]
}

locals {
  kustomization = <<KUSTOMIZATION
apiVersion: kustomize.config.k8s.io/v1beta1
kind: Kustomization
bases:
  - ../../base/flux-system/
resources:
- gotk-components.yaml
- gotk-sync.yaml
patches:
- patch: |-
    - op: add 
      path: /metadata/labels/istio-injection
      value: enabled
  target:
    kind: Namespace
    name: flux-system
KUSTOMIZATION
}
