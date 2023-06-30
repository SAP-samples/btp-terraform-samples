# Sample customer use case

## Overview

This use case is inspired by a sample setup of a customer taken from several hundred lines of Python scripts and modelled in a Terraform setup.

As with every customer scenario the usage of naming conventions for the resources and the validation of them is one important aspect to satisfy governance rules.

## Content of setup

The setup comprises the following resources:

- Creation of an SAP BTP subaccount according to the naming convention defined in the `variables.tf` file
- Creation of a Cloud Foundry environment within the subaccount in according to the naming convention defined in the `variables.tf` file
- Creation of an entitlement for the "Alert Notification" service in the subaccount

You can adapt the rules defined in the [variables.tf](variables.tf) file to your needs. In case you want to apply the rules, simply change the values for the variables in the [terraform.tfvars](terraform.tfvars) file.

## Deploying the resources

To deploy the resources you must:

1. Configure the provider in the `provider.tf` file
2. Initialize your workspace:
   
   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="terraform.tfvars 
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="terraform.tfvars
   ```

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="terraform.tfvars
```
