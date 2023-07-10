# Sample setup with multiple providers

## Overview

This sample showcases the usage of multiple Terraform providers in one setup. This scenario is needed in case of management of a SAP BTP subaccount including the Cloud Foundry space within it.

## Content of the setup

### Environments, services and applications

The setup comprises the following resources:

- Creation of an SAP BTP subaccount
- Creation of a Cloud Foundry environment within the subaccount
- Creation of a Cloud Foundry space
- Creation of entitlements for "XSUAA" (plan "apiaccess"), "Taskcenter" (plan "standard") and "Destination" (plan "light") in the subaccount
- Assignment of the following role colections to the users defined in the `users.tfvars` file:
   
  - Subaccount Administrator
  - Subaccount Service Administrator
  - SpaceManager
  - SpaceDeveloper
  - SpaceAuditor

## Deploying the resources

To deploy the resources you must:

1. Configure the providers in the `provider.tf` file
2. Initialize your workspace:
   
   ```bash
   terraform init
   ```

3. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="users.tfvars"
   ```

4. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="users.tfvars"
   ```

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="users.tfvars"
```
