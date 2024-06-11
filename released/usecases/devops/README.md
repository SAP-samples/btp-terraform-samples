# DevOps - 

## Overview

This sample shows how to create an account with DevOps tools like the SAP Continuous and Integration service and the SAP Automation Pilot. For the development we set up SAP Business Application Studio and the SAP HANA Cloud database.

## Content of setup

The setup comprises the following resources:

- Creation of the DevOps account
- Enablement of Cloudfoundry Environment - [see available regions and endpoints](https://help.sap.com/docs/btp/sap-business-technology-platform/regions-and-api-endpoints-available-for-cloud-foundry-environment)
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users
- Creation of CF environments
- Management of users and roles on org and space level

## Deploying the resources

To deploy the resources you must:

1. Create a file `secret.auto.tfvars` and maintain the credentials for the BTP and CF provider

   ```hcl
   btp_username = "<Email address of your BTP user>"
   btp_password = "<Password of your BTP user>"
   ```
   as an alternative you can also set the credentials as environment variables: 
   ```bash
   export BTP_USERNAME='<Email address of your BTP user>'
   export BTP_PASSWORD='<Password of your BTP user>'
   ```
2. Change the variables in the `samples.tfvars` file to meet your requirements

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

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
