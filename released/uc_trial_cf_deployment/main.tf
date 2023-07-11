# looks up the id of the pre-created trial account
module "trialaccount" {
  source = "./modules/trialaccount"
}

data "cloudfoundry_space" "dev" {
  org  = module.trialaccount.cloudfoundry.org_id
  name = "dev"
}

data "cloudfoundry_domain" "cfapps" {
  name = "cfapps.${module.trialaccount.cloudfoundry.region}.hana.ondemand.com"
}

resource "random_id" "suffix" {
  byte_length=1
}

resource "cloudfoundry_route" "helloterraform" {
  domain   = data.cloudfoundry_domain.cfapps.id
  space    = data.cloudfoundry_space.dev.id
  hostname = "helloterraform-${random_id.suffix.hex}"
}

data "cloudfoundry_service" "xsuaa" {
  name = "xsuaa"
}

resource "cloudfoundry_service_instance" "helloterraform_xsuaa" {
  name         = "helloterraform-xsuaa"
  space        = data.cloudfoundry_space.dev.id
  service_plan = data.cloudfoundry_service.xsuaa.service_plans["application"]
  json_params = jsonencode({
    xsappname   = "helloterraform-123"
    tenant-mode = "shared"
    scopes = [
      {
        name        = "helloterraform-123.Display"
        description = "Display"
      },
    ]
    role-templates = [
      {
        name        = "Viewer"
        description = ""
        scope-references = [
          "helloterraform-123.Display"
        ]
      }
    ]
  })
}

resource "cloudfoundry_app" "helloterraform" {
  space     = data.cloudfoundry_space.dev.id
  name      = "helloterraform"
  buildpack = "nodejs_buildpack"
  memory    = 512
  path      = zipper_file.helloterraform.output_path

  routes {
    route = cloudfoundry_route.helloterraform.id
  }

  service_binding {
    service_instance = cloudfoundry_service_instance.helloterraform_xsuaa.id
  }
}

resource "zipper_file" "helloterraform" {
  type        = "local"
  source      = "./assets/helloterraformapp"
  output_path = "./assets/helloterraform.zip"
}
