# SAP Discovery Center Mission: Process and approve your invoices with SAP Build Process Automation

This script simplifies the majority of tasks in the [Discovery Center Mission](https://discovery-center.cloud.sap/missiondetail/3260/), but a few configuration steps still require manual execution. The following tables provide status updates for these particular steps.

##### SETUP AND PREPARE PHASE
|   Steps                        | Automation status |
---------------------------------| ----------------
|Subscribe to SAP Build Process Automation Free Tier | Automated |
|Install the Desktop Agent       | Manual |
|Manage the Agent to execute automations|Manual| 
|Set up SAP S/4HANA Cloud        | Manual|
|SAP S/4HANA Cloud Masterdata    | Manual |
|Create relevant Destinations in the SAP BTP Subaccount| Manual|
|Create Destination in SAP Build Process Automation|Manual|
|Create Outlook folder and temp folder in system for Attachments|Manual|

## Execution
1. Modify the **terraform.tfvars** file to align it with your specific environment.
2. To authenticate and enable interaction with your BTP environments, ensure you set the necessary environment variables BTP_USERNAME and BTP_PASSWORD
    ```
    Mac & Linux 
        export TF_VAR_username=<your_username>
        export TF_VAR_password=<your_password>

    Windows(PS) 
        $env:TF_VAR_username=<your_username>
        $env:TF_VAR_password=<your_password>
    ```

