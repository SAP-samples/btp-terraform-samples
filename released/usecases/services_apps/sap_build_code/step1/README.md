# Setting up a subaccount with the SAP Build Code deployed - Step 1

## Overview

This script shows how to create a SAP BTP subaccount with `SAP Build Code` deployed.

## Content of setup

The setup comprises the following resources that are split into `step1` and `step2`:

- Creation of a SAP BTP subaccount
- Entitlement of all services and app subscrptions
- Role collection assignments to users

## Deploying the resources

To deploy the resources you must:

1. Change the variables in the `sample.tfvars` file to meet your requirements

2. Export the variables for user name and password

   ```bash
   export BTP_USERNAME='<Email address of your BTP user>'
   export BTP_PASSWORD='<Password of your BTP user>'
   ```

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

6. The outputs of this `step1` will be needed for the `step2` of this use case. In case you want to create a file with the content of the variables, you should set the variable `create_tfvars_file_for_step2` to `true`. This will create a `terraform.tfvars` file in the `step2` folder.

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
