# Sample Customer Use Case

## Overview

This use case is based on the one defined in the [subaccount_dev_setup](./../../released/subaccount_dev_setup) use case.

In addition the sample shows how to create a dev, test, production landscape for that use case.

This will be done by creating a directory for each landscape and creating a sub account for a department.

## Content of Setup

The setup comprises the following resources:

- Creation of a directory per landscape defined in the `*.tfvars` files
- Creation of an SAP BTP subaccount according to the naming convention defined in the variables.tf file and the variables defined in the `*.tfvars` files
- Assignment of each sub account to the respective landscape folder
- Creation of a Cloud Foundry environment within each subaccount in according to the naming convention defined in the variables.tf file
- Creation of entitlement for the "Alert Notification" service in each subaccount

You can adapt the rules defined in the [variables.tf](variables.tf) file to your needs. 
In case you want to apply the rules, simply change the values for the variables in the `*.tfvars` files.

## Run this sample

To run this sample, you need to apply different variables to the Terraform provider. In essence you apply the variable files to the terraform script you have built.

Execute by following these steps:
`
terraform init -upgrade
terraform plan
terraform apply -auto-approve -var_file="abc-b2b-us10-dev.tfvars"
terraform apply -auto-approve -var_file="abc-b2b-us10-tst.tfvars"
terraform apply -auto-approve -var_file="abc-b2b-us10-prd.tfvars"
`
