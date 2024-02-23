output "subaccount_id" {
  value = btp_subaccount.devcontainer_runtime.id
}

output "kyma_dashboard" {
  value = module.kyma_runtime.dashboard_url
}

output "kubeconfig" {
  value = module.kyma_runtime.kubeconfig
}
