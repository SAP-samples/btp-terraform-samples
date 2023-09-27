output "dashboard_url" {
  value = btp_subaccount_environment_instance.kymaruntime.dashboard_url
}

output "kubeconfig" {
  value = local_sensitive_file.kubeconfig.filename
}
