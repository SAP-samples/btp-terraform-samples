# Set Up SAP BTP Account using Terraform – Cloud Foundry

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
   ``If the terraform destroy fails with error `VCAP::CloudController::User with guid:`, Please remove the org member manually from BTP cockpit and retrigger `terraform    destroy` command.``

11. **Optional**: You can remove the Terraform state file (`terraform.tfstate`) manually if needed.

Please exercise caution when using this script, especially in production environments, and ensure you understand the resources that will be created or modified.
