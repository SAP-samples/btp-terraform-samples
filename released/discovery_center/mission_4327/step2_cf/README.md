# Set Up SAP BTP Account using Terraform – Cloud Foundry

The Terraform provider for SAP Business Technology Platform (BTP) enables you to automate the provisioning, management, and configuration of resources on SAP BTP. By leveraging this provider, you can simplify and streamline the deployment and maintenance of SAP BTP services and applications.

Currently, the SAP BTP provider is available in beta for non productive usage: [SAP BTP Terraform](https://registry.terraform.io/providers/SAP/btp/latest).

The Terraform script documented here automates the setup of an SAP BTP subaccount based on a predefined template. The scripts can be used create SAP BTP subaccount with Cloud Foundry or Kyma runtime. The Terraform script does the below configuration after creating a SAP BTP subaccount:

1. Configures the SAP BTP entitlements required to complete the mission. See [Setup SAP BTP Account using Terraform](https://github.com/SAP-samples/btp-terraform-samples/blob/main/released/discovery_center/mission_4327/step2_cf/README.md#entitlements).
2. Enables the SAP BTP runtime (Cloud Foundry or Kyma).
3. Creates the neccessary subscription to applications: SAP Business Application Studio (BAS), SAP Build Work Zone, standard edition, etc.
4. Assigns users the neccessary roles required to access the applications, such as SAP Business Application Studio.
5. Adds additional users to the subaccount.
### [Entitlements ](https://github.tools.sap/refapps/incidents-mgmt/blob/main/documentation/administrate/Prepare-BTP/Configure-BTP-CF.md)

| Service     |      Plan      |  Quota required |
| ------------- | :-----------: | ----: |
| Cloud Foundry Runtime     | MEMORY | 1 |
| SAP Build Work Zone, standard edition    |  Standard    |   1 |
| SAP HANA Cloud |   hana    |    1 |
| SAP HANA Cloud |   tools   |    1 |
| SAP HANA Schemas & HDI Containers |   hdi-shared   |    1 |

## Deploy the resources

To deploy the resources you must:
1. Clone repository `git clone https://github.com/SAP-samples/btp-terraform-samples.git`
2. Navigate to `released/discovery_center/mission_4327/setup_subaccount_cf`
3. You will be seeing these files named `main.tf`,`provider.tf`,`samples.tfvars`,`variables.tf`.
4. Create a file named `terraform.tfvars` and copy `samples.tfvars` content to `terraform.tfvars`. Update the variables to meet your requirements (By default free-tier plans are used, if you want to use it for production update in the `terraform.tfvars` accordingly)
Follow these steps to use the script:
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
   
11. **Optional**: You can remove the Terraform state file (`terraform.tfstate`) manually if needed.

Please exercise caution when using this script, especially in production environments, and ensure you understand the resources that will be created or modified.
