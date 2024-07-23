# looks up the id of the pre-created trial account
module "trialaccount" {
  source = "./modules/btp_trial_data"
}

data "cloudfoundry_space" "dev" {
  org  = module.trialaccount.cloudfoundry.org_id
  name = "dev"
}

data "cloudfoundry_domain" "cfapps" {
  name = "cfapps.${module.trialaccount.cloudfoundry.region}.hana.ondemand.com"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "cloudfoundry_route" "helloterraform" {
  domain = data.cloudfoundry_domain.cfapps.id
  space  = data.cloudfoundry_space.dev.id
  host   = "helloterraform-${random_id.suffix.hex}"
}

data "cloudfoundry_service" "xsuaa" {
  name = "xsuaa"
}

resource "cloudfoundry_service_instance" "helloterraform_xsuaa" {
  name         = "helloterraform-xsuaa"
  space        = data.cloudfoundry_space.dev.id
  service_plan = data.cloudfoundry_service.xsuaa.service_plans["application"]
  type         = "managed"
  parameters = jsonencode({
    xsappname   = "helloterraform-${random_id.suffix.hex}"
    tenant-mode = "shared"
    scopes = [
      {
        name        = "helloterraform-${random_id.suffix.hex}.Display"
        description = "Display"
      },
    ]
    role-templates = [
      {
        name        = "Viewer"
        description = ""
        scope-references = [
          "helloterraform-${random_id.suffix.hex}.Display"
        ]
      }
    ]
  })
}

resource "cloudfoundry_app" "helloterraform" {
  name       = "helloterraform"
  org_name   = module.trialaccount.cloudfoundry.org_name
  space_name = data.cloudfoundry_space.dev.name
  buildpacks = ["nodejs_buildpack"]
  memory     = "512M"
  path       = data.archive_file.helloterraform.output_path
  service_bindings = [
    {
      service_instance = cloudfoundry_service_instance.helloterraform_xsuaa.name
    }
  ]
  routes = [
    {
      route = cloudfoundry_route.helloterraform.url
    }
  ]
}

data "archive_file" "helloterraform" {
  type        = "zip"
  source_dir  = "./assets/helloterraformapp"
  output_path = "./assets/helloterraform.zip"
}
