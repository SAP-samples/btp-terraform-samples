## Step2: Export BTP Subaccount Using BTP Terraform Exporter.

The BTP Terraform provider is useful when you need to create a BTP Subaccount from scratch. However, if you already have an existing Subaccount and want to manage it using Terraform, you can use the Terraform Exporter.

The Terraform Exporter for SAP BTP (btptf CLI) is a convenient tool that simplifies the process of importing your existing SAP Business Technology Platform (BTP) resources into Terraform.

Pre-requisites:

- you need one existing BTP subaccount with resources in it (You already have one now).
- [Terraform Exporter Binaries](https://github.com/SAP/terraform-exporter-btp), Run the below command in your cli to check the exporter binaries have setup.

```bash
  btptf --help
 ```
 You should see below output.

 <img width="600px" src="assets/btptfhelp.png" alt="btptf help">

- If exporter is not avaialble, Go to [Setup Terraform Exporter](https://sap.github.io/terraform-exporter-btp/install/)

## Get the list of resources of a Subaccount in a JSON file

- Copy the subaccount ID you have created, And run the below command

```bash
btptf create-json --subaccount <Your Subaccount ID>
```
This command will create a file named `btp_resource_<subaccount_id>.json`

 You should see the following output:

 <img width="600px" src="assets/createJson.png" alt="btptf create-json">

If you want any of the resources (Entitlements, Role collections, Roles, etc) to be excluded from the Subaccount that you are going to export, Remove them from the `btp_resource_<subaccount_id>.json`.

You should see the `btp_resource_<subaccount_id>.json` like below:

<img width="600px" src="assets/btp_resourcesJson.png" alt="Json file lists all the resources">
 
## Generate configuration for Export

- If you are ready with updated Json, Run the below command to start exporting the resources.

```bash
btptf export-by-json --subaccount <subaccount ID> --path '</path/to/the/file>'
```

You have generated the terraform scripts now, you could see the scripts under `generated_configurations_<subaccount_id>` named directory.

You should see the following output:

<img width="600px" src="assets/exportbyjson.png" alt="export by json output">

## Export the resources

You can go the the `generated_configurations` folder, There you will see all the generated scripts.

Run the below command to bring the required subaccount resources under the management of terraform.

```bash
terraform apply
```
You should see the below output:

<img width="600px" src="assets/tfapply.png" alt="terraform apply output">

Now all the resources are exported and you can see the stae file under the folder `generated_configurations_<subaccount_id>`

> [!TIP]
> If you do not want to use Json file input, You can also use the `btptf export -S <subaccount_id>` command to export all the resources under one Subaccount.

### Summary

Congratulations! You have successfully completed the hands-on exercise.

This demonstrates how the BTP Terraform Exporter can be used to bring an existing BTP Subaccount under Terraform management. Without this tool, these tasks would be cumbersome and prone to errors.

### For Further References

Vist below links

- https://learning.sap.com/learning-journeys/getting-started-with-terraform-on-sap-btp

If you'd like to review some Terraform sample scripts, we've published them in the following repository for your reference.

```bash
git clone https://github.com/SAP-samples/btp-terraform-samples.git
```

you can find the exercises in the folder `released`.

Happy Terraforming!

