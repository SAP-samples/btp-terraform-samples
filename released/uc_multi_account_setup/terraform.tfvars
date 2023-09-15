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
        users                = ["johne.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["johne.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["johne.doe@test.com"]
      org_billing_managers = ["johne.doe@test.com"]
      org_auditors         = ["johne.doe@test.com"]
      spaces = [
        {
          space_name       = "dev"
          space_managers   = ["johne.doe@test.com"]
          space_developers = ["johne.doe@test.com"]
          space_auditors   = ["johne.doe@test.com"]
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
        users                = ["johne.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["johne.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["johne.doe@test.com"]
      org_billing_managers = ["johne.doe@test.com"]
      org_auditors         = ["johne.doe@test.com"]
      spaces = [
        {
          space_name       = "test"
          space_managers   = ["johne.doe@test.com"]
          space_developers = ["johne.doe@test.com"]
          space_auditors   = ["johne.doe@test.com"]
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
        users                = ["johne.doe@test.com"]
      },
      {
        role_collection_name = "Launchpad_Admin"
        users                = ["johne.doe@test.com"]
      },
    ]
    cf_environment_instance = {
      org_managers         = ["johne.doe@test.com"]
      org_billing_managers = ["johne.doe@test.com"]
      org_auditors         = ["johne.doe@test.com"]
      spaces = [
        {
          space_name       = "prod"
          space_managers   = ["johne.doe@test.com"]
          space_developers = ["johne.doe@test.com"]
          space_auditors   = ["johne.doe@test.com"]
        }
      ]
    }
  }
}