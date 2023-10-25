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

1. Copy the `samples.tfvars` to a file called `terraform.tfvars` and fill in the values for the variables. 
2. To authenticate and enable interaction with your BTP environments, ensure you set the necessary environment variables BTP_USERNAME and BTP_PASSWORD

    ```bash
    Mac & Linux 
        export BTP_USERNAME=<your_username>
        export BTP_PASSWORD=<your_password>
        export CF_USER=<your_username>
        export CF_PASSWORD=<your_password>

    Windows(PS) 
        $env:BTP_USERNAME=<your_username>
        $env:BTP_PASSWORD=<your_password>
        $env:CF_USER=<your_username>
        $env:CF_PASSWORD=<your_password>
    ```

3. Execute a `terraform init` to initialize the terraform providers and modules.
4. Execute a `terraform plan` to see what resources will be created.
5. Execute a `terraform apply` to create the resources.