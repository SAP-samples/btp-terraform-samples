variable "globalaccount" {
  description = "The subdomain of your trialaccount (e.g. '4605efebtrial-ga')"
}

variable "region" {
  description = "The BTP region"
  default     = "us10"
}

variable "developers" {
  description = "All the developers working on the project"
  default     = []
}

variable "cluster_name" {
  type    = string
  default = "kyma-gitops-showcase"
}

variable "fluxcd_git_repository" {
  type        = string
  description = "Url of git repository to bootstrap from"
}

variable "fluxcd_git_branch" {
  type        = string
  description = "Branch in repository to reconcile from"
  default     = "main"
}

variable "fluxcd_git_username" {
  type        = string
  description = "Username for basic authentication"
}

variable "fluxcd_git_password" {
  type        = string
  description = " Password for basic authentication"
  sensitive   = true
}
