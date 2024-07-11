# Discovery Center mission - Get started with Extended Planning and Analysis (xP&A)

## Overview

This sample shows how to set up your SAP BTP account for the Discovery Center Mission - [Get started with Extended Planning and Analysis (xP&A)](https://discovery-center.cloud.sap/missiondetail/3488/)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Enablement of Cloudfoundry Environment - [see available regions and endpoints](https://help.sap.com/docs/btp/sap-business-technology-platform/regions-and-api-endpoints-available-for-cloud-foundry-environment)
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources execute the following commands:

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