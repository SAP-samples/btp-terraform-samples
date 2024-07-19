# Prepare an Account for ABAP Trial

## Overview

This directory prepares a Trial account for ABAP Trial. 

The process is done in two steps:

1. In the directory `step1` the following configurations are applied:
   - Assignement the `abab-trial` entitlement with plan `shared` to the existing subaccount
   - Creation of a Cloud Foundry environment instance, in case Cloud Foundry is disabled for the subaccount

2. In the directory `step2` the following configurations are applied:
   - Creation a new Cloud Foundry space if no space with the provided name exists
   - Assignment of Cloud Foundry org and space roles
   - Creation of an ABAP Trial service instance in the Cloud Foundry space
   - Creation of a service key for the instance 

Please refer to the READMEs in the subdirectories for further instructions.