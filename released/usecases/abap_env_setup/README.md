# Sample Setup of an ABAP Environment on SAP BTP

## Overview

tbd

## Content of setup

tbd

## Deploying the resources

To deploy the resources you must:

1. Configure the provider in the `provider.tf` file
2. Initialize your workspace:

   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="terraform.tfvars" 
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="terraform.tfvars"
```
