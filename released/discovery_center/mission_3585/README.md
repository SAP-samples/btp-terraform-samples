# Discovery Center Mission: Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/protected/index.html#/missiondetail/3585) for your Enterprise BTP Account.

The respective setup of a trial account is described in [SAP-samples/btp-terraform-samples/tree/main/released/discovery_center/mission_3585_trial/README.md](https://github.com/SAP-samples/btp-terraform-samples/tree/main/released/discovery_center/mission_3585_trial/README.md)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Set your credentials as environment variables
   
   ```bash
   export BTP_USERNAME ='<Email address of your BTP user>'
   export BTP_PASSWORD ='<Password of your BTP user>'
   ```

2. Change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (besides user_email and password) is global account (i.e. its subdomain) and all user assignments
   
3. Then initialize your workspace:

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

6. Verify e.g., in [BTP Cockpit](https://cockpit.btp.cloud.sap) that a new subaccount with a SAP Business Application Studio subscription has been created and respective users were assigned to role collections

With this you have completed the quick account setup as described in the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/protected/index.html#/missiondetail/3585).

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```