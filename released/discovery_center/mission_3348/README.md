# Plan and Predict Workforce Demand (3945)

## Overview

This sample shows how to create a landscape for the Discovery Center Mission "Plan and Predict Workforce Demand" - [Discovery Center Mission](https://discovery-center.cloud.sap/missiondetail/3348/),

##  Setup

To deploy the resources you must:

1. Set the environment variables BTP_USERNAME and BTP_PASSWORD to pass credentials to the BTP provider to authenticate and interact with your BTP environments. 

    ```bash
    Mac & Linux 
        export BTP_USERNAME=<your_username>
        export BTP_PASSWORD=<your_password>

    Windows(PS) 
        $env:BTP_USERNAME=<your_username>
        $env:BTP_PASSWORD=<your_password>
    ```

2. Change the variables in the `samples.tfvars` file to meet your requirements

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise you might get error messages like e.g. `Error: The user could not be found: jane.doe@test.com`.


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

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy
```
