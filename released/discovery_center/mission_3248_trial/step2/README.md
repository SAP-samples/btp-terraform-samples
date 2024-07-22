# Prepare an Account for ABAP Trial - Step 2

## Overview

The second configuration step finalizes the ABAP Trial setup for the subaccount. The following configurations are applied:
- Creation a new Cloud Foundry space if no space with the provided name exists
- Assignment of Cloud Foundry org and space roles
- Creation of an ABAP Trial service instance in the Cloud Foundry space
- Creation of a service key for the instance

## Deploying the resources

To deploy the resources of this step execute the following commands:

1. Initialize your workspace:

   ```bash
   terraform init
   ```

> **Note** - Some variables of the output of the first step are needed as input for this step.

1. Assign the variable values in a `*.tfvars` file e.g., the global account subdomain

1. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="<name of your tfvars file>.tfvars" 
   ```

1. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="<name of your tfvars file>.tfvars"
   ```
