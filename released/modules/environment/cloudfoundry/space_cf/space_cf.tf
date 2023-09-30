# ------------------------------------------------------------------------------------------------------
# Define the required providers for this module
# ------------------------------------------------------------------------------------------------------
terraform {
  required_providers {
    cloudfoundry = {
      source  = "cloudfoundry-community/cloudfoundry"
      version = "0.51.3"
    }
  }
}

# ------------------------------------------------------------------------------------------------------
# Create the Cloud Foundry space
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space" "space" {
  name = var.name
  org  = var.cf_org_id
}

# ------------------------------------------------------------------------------------------------------
# Create the CF users
# ------------------------------------------------------------------------------------------------------
resource "cloudfoundry_space_users" "space-users" {
  space      = cloudfoundry_space.space.id
  managers   = var.cf_space_managers
  developers = var.cf_space_developers
  auditors   = var.cf_space_auditors
}
