# terramate.tm.hcl
globals {
  org_name     = "B2C"
  project_name = "proj-1234"
  costcenter   = "1234567890"
  region       = "us10"
  idp          = null
  globalaccount = "terraformintprod"
  bas_service_name = "sapappstudio"
  bas_plan        = "standard-edition"
  cf_landscape_label = "cf-us10-001"
  cf_plan           = "standard"
  cf_space_name     = "dev"
  cf_org_user       = ["jane.doe@test.com", "john.doe@test.com"]
  cf_space_managers = []
  cf_space_developers = []
  cf_space_auditors   = []
}