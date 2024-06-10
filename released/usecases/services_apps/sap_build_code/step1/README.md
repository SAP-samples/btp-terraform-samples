# Setting up a sub account with the SAP AI Core service deployed

## Overview

This script shows how to create a SAP BTP subaccount with the `SAP AI Core` service deployed

## Content of setup

The setup comprises the following resources:

- Creation of a SAP BTP subaccount
- Entitlement of the SAP AI Core service
- Entitlement and setup of SAP HANA Cloud (incl. hana cloud tools)
- Role collection assignments to users

## Deploying the resources

To deploy the resources you must:

1. Change the variables in the `sample.tfvars` file to meet your requirements


2. Export the variables for user name and password

   ```bash
   export BTP_USERNAME='<Email address of your BTP user>'
   export BTP_PASSWORD='<Password of your BTP user>'
   ```

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

6. The outputs of this `step1` will be needed for the `step2` of this use case. In case you want to create a file with the content of the variables, you can add another resource into the `main.tf` file, that looks like this:

   ```terraform
   resource "local_file" "output_vars_step1" {
      content  = <<-EOT
      globalaccount      = "${var.globalaccount}"
      cli_server_url     = ${jsonencode(var.cli_server_url)}

      subaccount_id      = "${btp_subaccount.build_code.id}"

      cf_api_endpoint    = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["API Endpoint"]}"
      cf_org_id          = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org ID"]}"
      cf_org_name        = "${jsondecode(btp_subaccount_environment_instance.cf.labels)["Org Name"]}"

      identity_provider  = "${var.identity_provider}"

      cf_org_admins      = ${jsonencode(var.cf_org_admins)}
      cf_space_developer = ${jsonencode(var.cf_space_developer)}
      cf_space_manager   = ${jsonencode(var.cf_space_manager)}
      EOT
      filename = "../step2/terraform.tfvars"
   }
   ```

This will create a `terraform.tfvars` file in the `step2` folder. 

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="sample.tfvars"
```
