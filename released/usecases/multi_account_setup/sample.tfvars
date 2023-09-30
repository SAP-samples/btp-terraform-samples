global_account = "<global-account>"
region         = "<region>"
project_name   = "<project-name>"

subaccounts = {
  DEV = {
    labels = {
      Stage = ["Development"]
    }
    entitlements = [
      {
        type   = "service"
        name   = "sapappstudio"
        plan   = "standard-edition"
        amount = null
      },
      {
        type   = "service"
        name   = "SAPLaunchpad"
        plan   = "standard"
        amount = null
      },
    ]
    subscriptions = [
      {
        app  = "sapappstudio"
        plan = "standard-edition"
      },
      {
        app  = "SAPLaunchpad"
        plan = "standard"
      },

    ]
    role_collection_assignments = [
      {
        role_collection_name = "Subaccount Viewer"
        users                = ["john.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["john.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["john.doe@test.com"]
      org_billing_managers = ["john.doe@test.com"]
      org_auditors         = ["john.doe@test.com"]
      spaces = [
        {
          space_name       = "dev"
          space_managers   = ["john.doe@test.com"]
          space_developers = ["john.doe@test.com"]
          space_auditors   = ["john.doe@test.com"]
        }
      ]
    }
  }
  TST = {
    labels = {
      Stage = ["Quality assurance"]
    }
    entitlements = [
      {
        type   = "service"
        name   = "SAPLaunchpad"
        plan   = "standard"
        amount = null
      },
    ]
    subscriptions = [
      {
        app  = "SAPLaunchpad"
        plan = "standard"
      },

    ]
    role_collection_assignments = [
      {
        role_collection_name = "Subaccount Administrator"
        users                = ["john.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["john.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["john.doe@test.com"]
      org_billing_managers = ["john.doe@test.com"]
      org_auditors         = ["john.doe@test.com"]
      spaces = [
        {
          space_name       = "test"
          space_managers   = ["john.doe@test.com"]
          space_developers = ["john.doe@test.com"]
          space_auditors   = ["john.doe@test.com"]
        }
      ]
    }
  }
  PRD = {
    labels = {
      Stage = ["Production"]
    }
    entitlements = [
      {
        type   = "service"
        name   = "SAPLaunchpad"
        plan   = "standard"
        amount = null
      },
    ]
    subscriptions = [
      {
        app  = "SAPLaunchpad"
        plan = "standard"
      },
    ]
    role_collection_assignments = [
      {
        role_collection_name = "Subaccount Administrator"
        users                = ["john.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["john.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["john.doe@test.com"]
      org_billing_managers = ["john.doe@test.com"]
      org_auditors         = ["john.doe@test.com"]
      spaces = [
        {
          space_name       = "prod"
          space_managers   = ["john.doe@test.com"]
          space_developers = ["john.doe@test.com"]
          space_auditors   = ["john.doe@test.com"]
        }
      ]
    }
  }
}