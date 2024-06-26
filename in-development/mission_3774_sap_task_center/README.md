# Discovery Center mission - Establish a Central Inbox with SAP Task Center

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Establish a Central Inbox with SAP Task Center](https://discovery-center.cloud.sap/index.html#/missiondetail/3774/)


## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlements of services
- Subscriptions to applications
- Creation of service instance
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Set the environment variables BTP_USERNAME and BTP_PASSWORD to pass credentials to the BTP provider to authenticate and interact with your BTP environments. 

   ```bash
   export BTP_USERNAME=<your_username>
   export BTP_PASSWORD=<your_password>
   ```

2. Set the environment variables CF_USERNAME and CF_PASSWORD to pass credentials to the CF provider to authenticate and interact with your CF environment. 

   ```bash
   export CF_USER=<your_username>
   export CF_PASSWORD=<your_password>
   ```

3. Change the variables in the `common_sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (beside user_email and password) is globalaccount (i.e. its subdomain) and the used custom_idp.


4. Change the variables in `sample.tfvars` file to meet your requirements

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise you might get error messages like e.g. `Error: The user could not be found: jane.doe@test.com`.


5. Initialize the workspace for step 1:

   ```bash
   terraform init
   ```

6. You can check what Terraform plans to apply for step 1 based on your configuration:

   ```bash
   terraform plan -var-file="../common_sample.tfvars" -var-file="sample.tfvars"
   ```

7. Apply your configuration for step 1 to provision the resources:

   ```bash
   terraform apply  -var-file="../common_sample.tfvars" -var-file="sample.tfvars"
   ```

8. Switch to the `2_disable_default_login` folder. The configuration in this folder disables the default IdP of the subaccount created in step 1 for user logon.

9. Change the variables in `sample.tfvars` file to meet your requirements

   > ⚠ NOTE: You must copy the `subaccount_id` from the output of step 1 and use it for step 2.


5. Initialize the workspace for step 2:

   ```bash
   terraform init
   ```

6. You can check what Terraform plans to apply for step 2 based on your configuration:

   ```bash
   terraform plan -var-file="../common_sample.tfvars" -var-file="sample.tfvars"
   ```

7. Apply your configuration for step 2 to provision the resources:

   ```bash
   terraform apply  -var-file="../common_sample.tfvars" -var-file="sample.tfvars"
   ```
