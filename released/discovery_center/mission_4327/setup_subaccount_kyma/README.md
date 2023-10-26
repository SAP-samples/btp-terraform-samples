# Terraform Script to setup SAP BTP Account 
The [Terraform provider](https://registry.terraform.io/providers/SAP/btp/latest) for SAP Business Technology Platform (BTP) enables you to automate the provisioning, management, and configuration of resources on SAP Business Technology Platform. By leveraging this provider, you can simplify and streamline the deployment and maintenance of BTP services and applications. Currently the BTP Terraform provider is available in beta for non productive usage. 

The Terraform script  documented here automates the setup of an SAP BTP subaccount based on a predefined template. The scripts can be used create BTP Sub Account with Cloud Foundry or Kyma runtime. The terraform scripts does the below configuration after creating a BTP Subaccount

1. Configure the BTP entitlements required to complete the Discovery Center mission
2. Enables BTP runtime Kyma
3. Create the neccessary Subscription to Software as Service(SaaS) Apps (SAP Business Application Studio(BAS), SAP Build Work Zone, standard edition etc)
4. Assgn users the neccessary roles required to access the SaaS Apps e.g BAS
5. Add additional users to the subaccount.

## Prerequisites

Before using this script, make sure you have Terraform downloaded and installed.

- **Install Terraform**: If you haven't already, download and install Terraform (We currently having an issue when using the Terraform CLI in version 1.6.x please install Terraform CLI version 1.5.7) from [here](https://www.terraform.io/downloads.html).

## BTP Sub Account Setup

- [BTP Subaccount with Kyma runtime evironment](#btp-subaccount-with-kyma-runtime-evironment)

 ### Entitlements

| Service     |      Plan      |  Quota required |
| ------------- | :-----------: | ----: |
| kyma Runtime     | aws | 1 |
| SAP Build Work Zone, standard edition    |  Standard    |   1 |
| SAP HANA Cloud |   hana    |    1 |
| SAP HANA Cloud |   tools   |    1 |
| SAP HANA Schemas & HDI Containers |   hdi-shared   |    1 |

## Deploying the resources

To deploy the resources you must:
1. Clone repository `git clone https://github.com/SAP-samples/btp-terraform-samples.git`
2. Navigate to `released/discovery_center/mission_4327/setup_subaccount_kyma`
3. You will be seeing these files named `main.tf`,`provider.tf`,`samples.tfvars`,`variables.tf`.
4. Create a file named terraform.tfvars and copy samples.tfvars content to terraform.tfvars. Update the variables to meet your requirements (By default free-tier plans are used, if you want to use it for production update in the terraform.tfvars accordingly) Follow these steps to use the script:
5. Set `BTP_USERNAME`,`BTP_PASSWORD`,`CF_USER` and `CF_PASSWORD` as ENV variables.
   
Windows PowerShell:
```Powershell
  $env:BTP_USERNAME="<your email address>"
  $env:BTP_PASSWORD="<your password>"
  $env:CF_USER="<your email address>"
  $env:CF_PASSWORD="<your password>"
```
Linux, macOS:
```mac OS
  export BTP_USERNAME="<your email address>"
  export BTP_PASSWORD="<your password>"
  export CF_USER="<your email address>"
  export CF_PASSWORD="<your password>"
```
6. **Install Terraform Plugins**: Open a terminal and navigate to the directory containing your Terraform configuration files. Run the following command to initialize and upgrade Terraform plugins:

    ```shell
    terraform init
    ```

7. **Review Changes**: Generate an execution plan to review the changes that will be made to your SAP BTP account. Run:

    ```shell
    terraform plan
    ```

8. **Apply Configuration**: Apply the Terraform configuration to create the SAP BTP subaccount and entitlements. Run:

    ```shell
    terraform apply
    ```

    Confirm the changes by typing "yes."

9. **Cleanup**: After your session or project is complete, you can delete the SAP BTP subaccount and associated resources to avoid charges:

    ```shell
    terraform destroy
    ```

    Confirm the resource destruction by typing "yes."

10. **Optional**: You can remove the Terraform state file (`terraform.tfstate`) manually if needed.

Please exercise caution when using this script, especially in production environments, and ensure you understand the resources that will be created or modified.

## Known issues

[Issues with Terraform CLI version 1.6.x - No resource type found](https://github.com/SAP/terraform-provider-btp/discussions/477)
If you are using Terraform CLI in version 1.6.x, please downgrade to version 1.5.7 of the Terraform CLI.
