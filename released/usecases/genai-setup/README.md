# Setting up a sub account with the SAP AI Core service deployed

## Overview

This script shows how to create a SAP BTP subaccount with the `SAP AI Core` service deployed

## Content of setup

The setup comprises the following resources:

- Creation of a SAP BTP subaccount
- Entitlement of the SAP AI Core service
- Entitlement and setup of SAP HANA Cloud (incl. hana cloud tools)
- Role collection assignments to users

## Deploying the resources

To deploy the resources you must:

1. Change the variables in the `samples.tfvars` file to meet your requirements

2. Initialize your workspace:

   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="sample.tfvars"
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="sample.tfvars"
   ```

5. You'll notice, that a `.env` file has been created, containing some environment variables that you can use for your genAI experiments.

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy
```
