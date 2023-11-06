# Setting up SAP Build Apps

## Overview

This sample shows how to create a SAP Build Apps app subscription in your subaccount.

## Content of setup

The setup comprises the following resources:

- Creation of a SAP BTP subaccount
- Entitlements of all services and app subscriptions for SAP Build Apps
- Role collection assignments to users

## Deploying the resources

To deploy the resources you must:

1. Export the variables for user name and password

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
terraform destroy
```
