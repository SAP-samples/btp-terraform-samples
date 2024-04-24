# Sample Setup of an ABAP Environment in an existing Subaccount

## Overview

The configuration provided in this folder contains the setup of an ABAP environment in an existing subaccount. The assumption is that the subaccount already has the right entitlements to create an ABAP environment assigned to it.

You have three options to deploy the resources:

1. You can create a new CF environment including the CF space for the ABAP environment.
1. You can an existing CF environment and create a new CF space for the ABAP environment.
1. You can use an existing CF environment and an existing CF space for the ABAP environment.

The variable values must be provided correspondingly in the `terraform.tfvars` file. We will provide the relevant parameters for each of the three options in the following sections. Be aware to also add the other required parameters like `globalaccount` and `cf_landscape`.

### Option 1: Create a new CF environment including the CF space for the ABAP environment

The `terraform.tfvars` file should look like this:

```terraform
create_cf_org       = true
create_cf_space     = true
project_name        = "my-abap-project"
cf_space_name       = "dev"
cf_space_developers = ["jane.dow@test.com"]
cf_space_managers   = ["john.doe@test.com"]
```

### Option 2: Use an existing CF environment and create a new CF space for the ABAP environment

The `terraform.tfvars` file should look like this:

```terraform
create_cf_space     = true
cf_org_id           = "ID of the existing CF organization"
cf_space_name       = "dev"
cf_space_developers = ["jane.dow@test.com"]
cf_space_managers   = ["john.doe@test.com"]
```

### Option 3: Use an existing CF environment and an existing CF space for the ABAP environment

The `terraform.tfvars` file should look like this:

```terraform
cf_org_id           = "ID of the existing CF organization"
cf_space_name       = "Name of the existing CF space"
```

## Deploying the resources

To deploy the resources you must:

1. Configure the provider in the `provider.tf` file
2. Initialize your workspace:

   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="terraform.tfvars" 
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="terraform.tfvars"
```
