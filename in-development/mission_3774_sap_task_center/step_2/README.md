# Sample Setup of an SAP Task Center on SAP BTP - Step 2

## Overview

This directory contains the setup of SAP Task Center from scratch namely a new subaccount including the relevant entitlements, a Cloud Foundry environment and a Cloud Foundry space. 

This directory contains the configuration the first step of the setup namely:

- Creation of service instance for SAP Task Center
- Creation of the service key for the service instance

## Deploying the resources

To deploy the resources of step 1 execute the following commands:

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

> **Note** - Some variables of the output of the first step are needed as input for the second step.

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="<name of your tfvars file>.tfvars"
```