terraform {
  required_providers {
    btp = {
      source  = "SAP/btp"
      version = "1.1.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "1.0.1"
    }
  }
}

provider "btp" {
  globalaccount = var.globalaccount
}

provider "flux" {
  kubernetes = {
    config_path = module.k8s_runtime.kubeconfig
  }

  git = {
    url    = var.fluxcd_git_repository
    branch = var.fluxcd_git_branch

    http = {
      username = var.fluxcd_git_username
      password = var.fluxcd_git_password
    }
  }
}
