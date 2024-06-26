# ------------------------------------------------------------------------------------------------------
# Provider configuration
# ------------------------------------------------------------------------------------------------------
# Your global account subdomain
globalaccount   = "your global account id goes here eg. 0645xxxx-1xxx-4xxx-bxxx-4xxxxxxxxxxx"
region          = "eu30"
subaccount_name = "DC Mission 3252 - Get Started with SAP BTP, Kyma runtime creating a Hello-World Function"

kyma_instance = {
  name            = "my-kyma-environment"
  region          = "europe-west3"
  machine_type    = "mx5.xlarge"
  auto_scaler_min = 3
  auto_scaler_max = 20
  createtimeout   = "1h"
  updatetimeout   = "35m"
  deletetimeout   = "1h"
}

# ------------------------------------------------------------------------------------------------------
# Project specific configuration (please adapt!)
# ------------------------------------------------------------------------------------------------------
subaccount_admins         = ["your.admin.email.address@your.company.com"]
subaccount_service_admins = ["your.admin.email.address@your.company.com"]

