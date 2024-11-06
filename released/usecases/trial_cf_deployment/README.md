# Deploying a Cloud Foundry App to SAP BTP Trial

## Overview

This sample shows how to deploy a Cloud Foundry application to SAP BTP trial.

## Content of setup

The setup comprises the following resources:

- Creation of a Cloud Foundry domain and route
- Creation of XSUAA service instance
- Deployment of "Hello World" application

## Pre-requisite for the setup

- You must have an SAP BTP trial account with a subaccount created named trial.
- The BTP subaccount should be enabled for Cloud Foundry, specifically with the Application Runtime is added.
- Ensure that you have created a space named Dev within the Cloud Foundry environment of your subaccount.
- Verify that the XSUAA service is available in your Cloud Foundry environment.

## Deploying the resources

To deploy the resources you must:

1. Configure the global account your `provider.tf` file

2. Initialize your workspace:

   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply
   ```

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy
```
