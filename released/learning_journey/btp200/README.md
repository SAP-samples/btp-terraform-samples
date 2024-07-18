# Learning Journey BTP200
## Overview

This folder contains the files for the Terraform exercise of the SAP Learing Journey BTP200

## Content of setup

The setup comprises the following resources:

- Creation of an SAP BTP subaccount or using an existing subaccount
- Entitlements of services
   * SAP Business Application Studio
   * SAP Build Work Zone, standard edition
   * Continous Integration & Delivery - optional
  
- Subscriptions of the services
- Role collection assignments to users

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

1. Create a file `secret.auto.tfvars` and maintain the credentials for the BTP provider

   ```hcl
   btp_username = "<Email address of your BTP user>"
   btp_password = "<Password of your BTP user>"
   ```
   as an alternative you can set this credentials also as environment variables
   
   ```bash
   export btp_username ='<Email address of your BTP user>'
   export btp_password ='<Password of your BTP user>'
   ```

3. Change the variables in the `terraform.tfvars` file to meet your requirements
   > The minimal set of parameters you should specify (beside btp_user and btp_password) is globalaccount (i.e. its subdomain - you find it in the SAP BTP cockpit in the Account Explorer). If you don't have the global account administrator privileg, you need to have access to a subaccount with the subaccount administrator privileg. In that case you need to set the subaccount_id (You can find it in the SAP BTP cockpit on the subaccount overview page).

 

4. Initialize your workspace:

   ```bash
   terraform init
   ```

5. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan 
   ```

6. Apply your configuration to provision the resources:

   ```bash
   terraform apply 
   ```
7. Remove the changes you have done with this script
   
   ```bash
   terraform destroy 
   ```
