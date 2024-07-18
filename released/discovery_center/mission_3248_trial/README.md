# Prepare an Account for ABAP Trial

## Overview

This directory contains the setup of an ABAP environment from scratch namely a new subaccount including the relevant entitlements, a Cloud Foundry environment and a Cloud Foundry space. 

The process is done in two steps:

1. In the directory `step1` the following resources are created:
   - a new subaccount
   - the entitlements for the ABAP environment
   - the subscription to the ABAP web access
   - the Cloud Foundry environment
   - The trust setup to the custom IdP 

2. In the directory `step2` the following resources are created:
   - the assignment of Cloud Foundry org roles
   - a new Cloud Foundry space
   - the assignment of Cloud Foundry space roles
   - the ABAP environment (service instance)
   - the service keys for the ABAP environment (ADT, Communication arrangrement `SAP_COM_0193`)   

## Deploying the resources

To deploy the resources you must navigate into the `step1` and `step2` directories and execute the following commands:

1. Initialize your workspace:

   ```bash
   terraform init
   ```

1. Assign the variable values in a `*.tfvars` file e.g., the global account subdomain

1. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="<name of your tfvars file>.tfvars" 
   ```

1. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="<name of your tfvars file>.tfvars"
   ```

> **Note** - Some variables of the output of the first step are needed as input for the second step.

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="<name of your tfvars file>.tfvars"
```
