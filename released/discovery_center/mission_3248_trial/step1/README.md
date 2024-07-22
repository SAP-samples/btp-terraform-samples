# Prepare an Account for ABAP Trial - Step 1

## Overview

The first configuration step prepares your existing Trial subaccount for ABAP Trial. The following configurations are applied:
- Assignement the `abab-trial` entitlement with plan `shared` to the existing subaccount
- Creation of a Cloud Foundry environment instance, in case Cloud Foundry is disabled for the subaccount

## Deploying the resources

To deploy the resources of this step execute the following commands:

1. Initialize your workspace:

   ```bash
   terraform init
   ```

1. Assign the variable values in a `*.tfvars` file e.g., the global account subdomain

1. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="<name of your tfvars file>.tfvars" 
   ```

1. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="<name of your tfvars file>.tfvars"
   ```

> **Note** - Some outputs of the first step are needed as input for the second step.
