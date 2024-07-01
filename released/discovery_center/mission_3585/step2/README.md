# Discovery Center mission - Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App (Step 2)

## Overview

Step 2 of this sample shows how to Cloud Foundry environment for the Discovery Center Mission - [Get Started on SAP BTP with SAPUI5/Fiori - Create a Hello World App](https://discovery-center.cloud.sap/missiondetail/3585/)

## Content of setup

This setup step comprises the following resources:

- Creation of a Cloud Foundry space
- Cloud Foundry role assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Set the environment variables CF_USER and CF_PASSWORD to pass credentials to the Cloud Foundry provider to authenticate and interact with your BTP environments. 

   ```bash
   export CF_USER=<your_username>
   export CF_PASSWORD=<your_password>
   ```

2. Change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (besides user_email and password) is Cloud Foundry API URL and all Cloud Foundry user assignments

   > ⚠ NOTE: You should pay attention **specifically** to the users defined in the samples.tfvars whether they already exist in your SAP BTP accounts. Otherwise, you might get error messages like, e.g., `Error: The user could not be found: jane.doe@test.com`.


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

## When finished

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
