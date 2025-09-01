# Needed for subdomain uniqueness
resource "random_uuid" "self" {}

# Needed for output to construct the subaccount URL
data "btp_globalaccount" "self" {}

locals {
  # Define a mapping of regions to their respective geo regions
  region_mapping = {
    "br10" = "LATAM"
    "jp10" = "APAC"
    "ap10" = "APAC"
    "ap11" = "APAC"
    "ap12" = "APAC"
    "ca10" = "AMER"
    "eu10" = "EMEA"
    "eu11" = "EMEA"
    "us10" = "AMER"
    "us11" = "AMER"
    "us30" = "AMER"
    "eu30" = "EMEA"
    "in30" = "APAC"
    "il30" = "EMEA"
    "jp30" = "APAC"
    "jp31" = "APAC"
    "ap30" = "APAC"
    "br30" = "APAC"
    "eu20" = "EMEA"
    "ap20" = "APAC"
    "ap21" = "APAC"
    "br20" = "APAC"
    "ca20" = "AMER"
    "cn20" = "APAC"
    "us20" = "AMER"
    "jp20" = "APAC"
    "us21" = "AMER"
    "ch20" = "EMEA"
  }

  # Define default entitlements per stage
  default_entitlements = {
    "Dev" = {
      "aicore"                  = ["standard"],
      "ai-launchpad"            = ["standard"]
      "alert-notification"      = ["standard"],
      "application-logs"        = ["standard=1"],
      "build-workzone-standard" = ["standard"],
      "credstore"               = ["standard=1"],
      "jobscheduler"            = ["standard=1"],
      "hana-cloud"              = ["hana"],
      "transport"               = ["standard"],
    },
    "Test" = {
      "ai-launchpad"            = ["standard"]
      "alert-notification"      = ["standard"],
      "application-logs"        = ["standard=1"],
      "build-workzone-standard" = ["standard"],
      "credstore"               = ["standard=1"],
      "jobscheduler"            = ["standard=1"],
      "hana-cloud"              = ["hana"],
      "transport"               = ["standard"],
    },
    "Prod" = {
      "ai-launchpad"            = ["standard"]
      "alert-notification"      = ["standard"],
      "application-logs"        = ["standard=1"],
      "build-workzone-standard" = ["standard"],
      "credstore"               = ["standard=1"],
      "jobscheduler"            = ["standard=1"],
      "hana-cloud"              = ["hana"],
      "transport"               = ["standard"],
    }
  }

  # Naming conventions
  subaccount_name        = "${var.subaccount_name} ${var.stage}"
  subaccount_subdomain   = "${replace(lower(var.subaccount_name), " ", "-")}-${lower(var.stage)}-${random_uuid.self.result}"
  subaccount_description = "Subaccount ${var.subaccount_name} in the ${var.stage} stage for ${var.department}."
  cf_org_name            = "CF-${var.subaccount_name}-${var.stage}"
}

resource "btp_subaccount" "self" {
  name         = local.subaccount_name
  subdomain    = local.subaccount_subdomain
  region       = var.region
  description  = local.subaccount_description
  usage        = var.stage == "Prod" ? "USED_FOR_PRODUCTION" : "NOT_USED_FOR_PRODUCTION"
  beta_enabled = var.stage == "Dev" ? true : false
  labels = {
    "Cost Center"    = ["${var.cost_center}"]
    "Contact Person" = ["${var.contact_person}"]
    "Department"     = ["${var.department}"]
    "Region"         = ["${lookup(local.region_mapping, var.region, "UNKNOWN")}"]
  }
}

module "sap_btp_entitlements" {
  source  = "aydin-ozcan/sap-btp-entitlements/btp"
  version = "~> 1.0.1"

  subaccount   = btp_subaccount.self.id
  entitlements = local.default_entitlements[var.stage]
}

data "btp_subaccount_environments" "all" {
  subaccount_id = btp_subaccount.self.id
}

resource "terraform_data" "cf_landscape_label" {
  input = [for env in data.btp_subaccount_environments.all.values : env if env.service_name == "cloudfoundry" && env.environment_type == "cloudfoundry"][0].landscape_label
}


resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.self.id
  name             = local.cf_org_name
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "standard"
  landscape_label  = terraform_data.cf_landscape_label.output
  parameters = jsonencode({
    instance_name = local.subaccount_subdomain
  })
}

resource "btp_subaccount_role_collection_assignment" "emergency_admins" {
  for_each = toset(var.emergency_subaccount_admins)

  subaccount_id        = btp_subaccount.self.id
  role_collection_name = "Subaccount Administrator"
  user_name            = each.value
}
