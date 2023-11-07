output "kyma_dashboard_url" {
  value = module.k8s_runtime.dashboard_url
}

output "kyma_kubeconfig" {
  value = module.k8s_runtime.kubeconfig
}
