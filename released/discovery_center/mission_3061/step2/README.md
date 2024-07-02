# Sample Setup of an ABAP Environment on SAP BTP - Step 2

## Overview

This directory contains the setup of an ABAP environment from scratch namely a new subaccount including the relevant entitlements, a Cloud Foundry environment and a Cloud Foundry space. 

This directory contains the configuration for the second step of the setup namely:

- the assignment of Cloud Foundry org roles
- a new Cloud Foundry space
- the assignment of Cloud Foundry space roles
- the ABAP environment (service instance)
- the service keys for the ABAP environment (ADT, Communication arrangrement `SAP_COM_0193`)   

## Deploying the resources

To deploy the resources of step 2 execute the following commands:

1. Initialize your workspace:

   ```bash
   terraform init
   ```

> **Note** - Some variables of the output of the first step are needed as input for this step.

1. Assign the variable values in a `*.tfvars` file e.g., the global account subdomain

1. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="<name of your tfvars file>.tfvars" 
   ```

1. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="<name of your tfvars file>.tfvars"
   ```


## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="<name of your tfvars file>.tfvars"
```
