# Discovery Center mission - Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App

## Overview

This sample shows how to set up your SAP BTP account for the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/missiondetail/3585/)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Enablement of Cloudfoundry Environment - [see available regions and endpoints](https://help.sap.com/docs/btp/sap-business-technology-platform/regions-and-api-endpoints-available-for-cloud-foundry-environment)
- Entitlements of services
   * SAP Business Application Studio
   * SAP Build Work Zone, standard edition
   * Continous Integration & Delivery - Optional
- Subscriptions to applications
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Set the environment variables BTP_USERNAME and BTP_PASSWORD to pass credentials to the BTP provider to authenticate and interact with your BTP environments. 

   ```bash
   export BTP_USERNAME=<your_username>
   export BTP_PASSWORD=<your_password>
   ```

2. Change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (besides user_email and password) is global account (i.e. its subdomain) and the used custom_idp and all user assignments

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise, you might get error messages like, e.g., `Error: The user could not be found: jane.doe@test.com`.


3. Initialize your workspace:

   ```bash
   terraform init
   ```

4. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="sample.tfvars"
   ```

6. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="sample.tfvars"
   ```

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
