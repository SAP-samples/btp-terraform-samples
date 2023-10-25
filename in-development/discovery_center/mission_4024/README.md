# Discovery Center mission - Keep the Core Clean Using SAP Build Apps with SAP S/4HANA

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Keep the Core Clean Using SAP Build Apps with SAP S/4HANA](https://discovery-center.cloud.sap/index.html#/missiondetail/4024/)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Create a file `secret.auto.tfvars` and maintain the credentials for the BTP provider

   ```hcl
   user_email = "<Email address of your BTP user>"
   password = "<Password of your BTP user>"
   ```

2. Change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (beside user_email and password) is globalaccount (i.e. its subdomain) and the used custom_idp and all user assignments

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise you might get error messages like e.g. `Error: The user could not be found: jane.doe@test.com`.


3. Initialize your workspace:

   ```bash
   terraform init
   ```

4. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="sample.tfvars"
   ```

5. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="sample.tfvars"
   ```
