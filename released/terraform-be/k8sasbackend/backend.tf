terraform {
  backend "kubernetes" {
    secret_suffix = "state"
    config_path   = "/path/to/your/kubeconfig"
    namespace     = "state-storage"
  }
}
