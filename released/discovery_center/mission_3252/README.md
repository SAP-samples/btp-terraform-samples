# Discovery Center mission - Get Started with SAP BTP, Kyma runtime creating a Hello-World Function

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Get Started with SAP BTP, Kyma runtime creating a Hello-World Function](https://discovery-center.cloud.sap/protected/index.html#/mymissiondetail/94380/?tab=projectboard)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlement to Kyma runtime
- Provisioning Kyma runtime

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Set the environment variables BTP_USERNAME and BTP_PASSWORD to pass credentials to the BTP provider to authenticate and interact with your BTP environments. 

   ```bash
   export BTP_USERNAME=<your_username>
   export BTP_PASSWORD=<your_password>
   ```
Alternativelly set:
    ```bash
    export BTP_ENABLE_SSO=true
    ```

2. Change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (beside user_email and password) is globalaccount (i.e. its subdomain)

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
