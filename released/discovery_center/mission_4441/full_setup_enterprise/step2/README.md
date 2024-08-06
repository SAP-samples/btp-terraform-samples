# Setting up a subaccount with the SAP Build Code deployed - Step 2

## Overview

This script shows how to create a SAP BTP subaccount with `SAP Build Code` deployed. Step 2 comprises all activities that depend on the Cloud Foundry environment created in step 1.

## Deploying the resources

To deploy the resources you must:

1. If you did not create a `tfvars` file in step 1 (via the variable `create_tfvars_file_for_step2`) you must manually Take the output of step 1 and transfer it in a `tfvars` file e.g. `sample.tfvars` file to meet your requirements. Of course you can also further adjust the generated `tfvars` file from step 1.

2. If not already done in step 1, initialize your workspace:

   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration. If you use the generated `tfvars` file from step 1 you do not need need to explicitly add the filename to the command:

   ```bash
   terraform plan 
   ```

   In case you manually created the `tfvars` file you need to add the filename to the command:

   ```bash
   terraform plan -var-file="sample.tfvars" 
   ```

4. According to the variants of step 3. apply your configuration to provision the resources either via:

   ```bash
   terraform apply
   ```

   or via:

   ```bash
   terraform apply -var-file="sample.tfvars"
   ```

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the command fitting your setup:

```bash
terraform destroy 
```

or:

```bash
terraform destroy -var-file="sample.tfvars" 
```
