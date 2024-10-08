# Discovery Center mission: Get started with Extended Planning and Analysis (xP&A) (3488)

## Overview

This sample shows how to setup your SAP BTP account for the Discovery Center Mission - [Get started with Extended Planning and Analysis (xP&A)](https://discovery-center.cloud.sap/index.html#/missiondetail/3488/) for your Enterprise BTP Account.

## Content of setup (step1)

The setup comprises the following resources:

- Creation of the SAP BTP subaccount
- Entitlements of services
- Subscriptions to applications
- Role collection assignments to users
- Creation of CF environment and CF org

After this a setup step2 will create CF space and a SAP Analytics Cloud CF service instance in the before created CF; org users and roles will be assigned on CF org and space level

## Deploying the resources

Make sure that you are familiar with SAP BTP and know both the [Get Started with btp-terraform-samples](https://github.com/SAP-samples/btp-terraform-samples/blob/main/GET_STARTED.md) and the [Get Started with the Terraform Provider for BTP](https://developers.sap.com/tutorials/btp-terraform-get-started.html)

To deploy the resources you must:

### Setup Step1

1. Set your credentials as environment variables
   
   ```bash
   export BTP_USERNAME ='<Email address of your BTP user>'
   export BTP_PASSWORD ='<Password of your BTP user>'
   ```

2. Go into folder `step1` and change the variables in the `sample.tfvars` file to meet your requirements

   > The minimal set of parameters you should specify (besides user_email and password) is global account (i.e. its subdomain) and the used custom_idp and all user assignments
   
   > Keep the setting `create_tfvars_file_for_step2 = true` so that a `terraform.tfvars` file is created which contains your needed variables to execute setup `step2` without specifying them again in sample.tfvars there.

3. In folder `step1` you initialize your workspace:

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

6. Verify e.g., in BTP cockpit that a new subaccount with a SAP HANA Cloud and SAP Build Work Zone subscriptions have been created.

### Setup Step2

7. Navigate into step2 directory and initialize your workspace there as well:

   ```bash
   terraform init
   ```
8. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="terraform.tfvars"
   ```

9. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="terraform.tfvars"
   ```
10. Verify e.g., in BTP cockpit that after step2 the specified users in sample.tfvars have been assigned with roles in the created cloundfoundry org and space.

With this you have completed the quick account setup as described in the Discovery Center Mission - [Get started with Extended Planning and Analysis (xP&A)](https://discovery-center.cloud.sap/index.html#/missiondetail/3488/).

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="terraform.tfvars"
```