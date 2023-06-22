# Sample Customer Use Case

## Overview

This use case is inspired by a sample setup of a customer taken from several hundred lines of Python scripts and modelled in a Terraform setup.

As with every customer scenario the usage of naming conventions for the resources and the validation of them is one important aspect to satisfy governance rules.

## Content of Setup

The setup comprises the following resources:

- Creation of an SAP BTP subaccount according to the naming convention defined in the variables.tf file
- Creation of a Cloud Foundry environment within the subaccount in according to the naming convention defined in the variables.tf file
- Creation of entitlement for the "Alert Notification" service in the subaccount

You can adapt the rules defined in the [variables.tf](variables.tf) file to your needs. In case you want to apply the rules, simply change the values for the variables in the [terraform.tfvars](terraform.tfvars) file.
