# Discovery Center Mission: Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/protected/index.html#/missiondetail/3585) for your trial account.

The respective setup of an Enterprise account is described in [SAP-samples/btp-terraform-samples/tree/main/released/discovery_center/mission_3585/README.md](https://github.com/SAP-samples/btp-terraform-samples/tree/main/released/discovery_center/mission_3585_trial/README.md)

## Important: Trial Account Prerequisites

Contrary to an Enterprise account (where the setup will happen in a newly created subaccount, where entitlements are added), we make the assumption that in your trial account there is already a subaccount (by default named 'trial') with all the required service entitlements and not already in use!

In a newly created trial account this is already true and you are good to go immediately with this setup. 

But if you have already used services and/or setup subscriptions in your trial account, you have to make sure that you free up these resources to start with this setup here (i.e. delete the corresponding services/subscriptions used for this Discover Center Mission setup). Otherwise the setup would fail!

For this mission setup the following resource (app subscription) is used: 

- SAP Build Work Zone, standard edition (Subscription)

You could delete these resources in your [BTP Trial Cockpit](https://cockpit.btp.cloud.sap/trial) on the corresponding trial subaccount pages
- Services > Instances and Subscriptions

## Content of setup

The setup comprises the following resources:

- Subscription to applications
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

   > The minimal set of parameters you should specify (besides user_email and password) is global account (i.e. its subdomain), trial subaccount ID and all user assignments
   
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

6. Verify e.g., in [BTP Trial Cockpit](https://cockpit.btp.cloud.sap/trial) that SAP Build Workzone subscriptions have been created and respective users were assigned to role collections

With this you have completed the quick account setup as described in the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/protected/index.html#/missiondetail/3585).

## In the end

You probably want to remove the assets after trying them out. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```