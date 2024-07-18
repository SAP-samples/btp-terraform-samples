# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount             = "your global account id goes here eg. 0645xxxx-1xxx-4xxx-bxxx-4xxxxxxxxxxx"
subaccount_name           = "DC Mission 3252 - Get Started with SAP BTP, Kyma runtime creating a Hello-World Function"
region                    = "eu10"
subaccount_admins         = ["your.admin.email.address@your.company.com"]
subaccount_service_admins = ["your.admin.email.address@your.company.com"]

# Kyma instance parameters. When set to null, the name will be set to the subaccount subdomain and the
# first available cluster region for the subaccount will be selected.
kyma_instance_parameters = {
  name            = "my-kyma-environment"
  region          = "eu-central-1"
  machine_type    = "mx5.xlarge"
  auto_scaler_min = 3
  auto_scaler_max = 20
}
