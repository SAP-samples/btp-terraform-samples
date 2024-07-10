# SAP Discovery Center Mission: Process and approve your invoices with SAP Build Process Automation

This script simplifies the majority of tasks in the [Discovery Center Mission](https://discovery-center.cloud.sap/missiondetail/3260/), but a few configuration steps still require manual execution. The following tables provide status updates for these particular steps.

## SETUP AND PREPARE PHASE

|   Steps                                                       | Automation status |
---------------------------------                               | ----------------
|Subscribe to SAP Build Process Automation Free Tier            | Automated
|Install the Desktop Agent                                      | Manual
|Manage the Agent to execute automations                        | Manual
|Set up SAP S/4HANA Cloud                                       | Manual
|SAP S/4HANA Cloud Masterdata                                   | Manual
|Create relevant Destinations in the SAP BTP Subaccount         | Manual
|Create Destination in SAP Build Process Automation             | Manual
|Create Outlook folder and temp folder in system for Attachments| Manual

## Execution

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
   terraform plan -var-file="samples.tfvars"
   ```

5. Apply your configuration to provision the resources:

   ```bash
   terraform apply -var-file="samples.tfvars"
   ```

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy
```