# Discovery Center Mission: Develop a CAP-based (multitenant) application using GenAI and RAG (4371)

## Overview

This sample shows how to create a landscape for the Discovery Center Mission - [Develop a CAP-based (multitenant) application using GenAI and RAG](https://discovery-center.cloud.sap/missiondetail/4371/)

## Content of setup

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users
- Management of users and roles on org and space level

## Deploying the resources

To deploy the resources you must:

1. Export environment variables BTP_USERNAME, BTP_PASSWORD, CF_USER, and CF_PASSWORD with your username and password for the custom IdP of your global account.

2. Change the variables in the `samples.tfvars` file in the main folder to meet your requirements

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise you might get error messages like e.g. `Error: The user could not be found: jane.doe@test.com`.

3. Execute the apply.sh script.

4. Verify e.g., in BTP cockpit that a new subaccount with a integration suite, SAP Business Application Studio, CF environment instance and a CF space have been created.

   ```bash
   terraform init
   ```

5. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="sample.tfvars"
   ```

6. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="sample.tfvars"
   ```

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
