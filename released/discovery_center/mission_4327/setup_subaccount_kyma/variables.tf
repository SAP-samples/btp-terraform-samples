######################################################################
# Customer account setup
######################################################################
# subaccount
variable "globalaccount" {
  type        = string
  description = "The globalaccount subdomain."
}
# subaccount
variable "subaccount_name" {
  type        = string
  description = "The subaccount name."
}
# Region
variable "region" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "us10"
}
# Kyma cluster name
variable "kyma_cluster_name" {
  type        = string
  description = "The name for the kyma cluster"
  default     = "my-kyma-cluster"
}
# kymaruntime plan
variable "kyma_plan_name" {
  type        = string
  description = "The name for the kyma cluster"
  default     = "aws"
}
# CLI server
variable "cli_server_url" {
  type        = string
  description = "The BTP CLI server URL."
  default     = "https://cpcli.cf.eu10.hana.ondemand.com"
}
#subaccount admins
variable "subaccount_admins" {
  type        = list(string)
  description = "Defines the colleagues who are added to each subaccount as subaccount administrators."
  default     = ["jane.doe@test.com", "john.doe@test.com"]
}
variable "username" {
  description = "BTP username"
  type        = string
}

variable "password" {
  description = "BTP user password"
  type        = string
  sensitive   = true
}
variable "btp_user" {
description = "BTP user email"
type = string
}
variable "administrators" {
  description = "Users to be assigned as administrators."
  type        = set(string)
  default     = []
}
variable "oidc" {
  description = "Custom OpenID Connect IdP to authenticate users in your Kyma runtime."
  type = object({
    # the URL of the OpenID issuer (use the https schema)
    issuer_url = string

    # the client ID for the OpenID client
    client_id = string

    #the name of a custom OpenID Connect claim for specifying user groups
    groups_claim = string

    # the list of allowed cryptographic algorithms used for token signing. The allowed values are defined by RFC 7518.
    signing_algs = set(string)

    # the prefix for all usernames. If you don't provide it, username claims other than “email” are prefixed by the issuerURL to avoid clashes. To skip any prefixing, provide the value as -.
    username_prefix = string

    # the name of a custom OpenID Connect claim for specifying a username
    username_claim = string
  })
  default = null
}
#################################
# Plan_name update for services
#################################
variable "bas_plan_name" {
description = "BAS plan"
type = string
default = "free-tier"
}
variable "build_workzone_plan_name" {
description = "Build Workzone plan"
type = string
default = "free-tier"
}
variable "hana-cloud_plan_name" {
description = "hana-cloud plan"
type = string
default = "free"
}
