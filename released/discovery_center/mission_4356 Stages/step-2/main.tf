######################################################################
# Create space using CF provider
######################################################################
resource "cloudfoundry_space" "dev" {
  name      = "DEV"
  org       = var.cf_org_id
}