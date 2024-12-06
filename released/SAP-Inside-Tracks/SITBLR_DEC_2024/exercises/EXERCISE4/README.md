# Exercise 4 - Setup a Cloud Foundry environment

## Goal of this Exercise 🎯

In this section, we will create a Cloud Foundry environment in the subaccount using Terraform.We will define the necessary resources directly in the Terraform configuration. This approach allows us to maintain a simple structure while meeting the requirements.

## Creation of a Cloud Foundry environment

The Cloud Foundry Application Runtime service needs to be entitled to the subaccount. To achieve this, add the following resource to your Terraform configuration:

### Step 1: Add the resources to the Terraform configuration for cloudfoundry setup

First we need to add one more local variable in the `main.tf` file. Open the `main.tf` file and add the following code to the `locals` block:

```terraform
project_subaccount_cf_org = replace("${var.org_name}_${lower(var.project_name)}-${lower(var.stage)}", " ", "_")
```
We will define the variables in the `variable.tf` file. Open the `variable.tf` file and add the following code.


```terraform
variable "cf_landscape_label" {
  type        = string
  description = "The region where the project account shall be created in."
  default     = "cf-us10-001"
}
```

Then add the following code to the `main.tf`

```terraform
resource "btp_subaccount_environment_instance" "cloudfoundry" {
  subaccount_id    = btp_subaccount.project.id
  name             = local.project_subaccount_cf_org
  landscape_label  = var.cf_landscape_label
  environment_type = "cloudfoundry"
  service_name     = "cloudfoundry"
  plan_name        = "trial"
  parameters = jsonencode({
    instance_name = local.project_subaccount_cf_org
  })
  timeouts = {
    create = "1h"
    update = "35m"
    delete = "30m"
  }
}
```

### Step 2: Adjust the output variables

As we are using the output variables, we need to adjust the output variables in the `outputs.tf` file. Open the `outputs.tf` file and add the following code:

```terraform
output "cloudfoundry_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the cloudfoundry org connected to the project account."
}
```
### Step 3: Apply the changes

1. Plan the Terraform configuration to see what will be created:

    ```bash
    terraform plan
    ```

    The output should look like this:

    <img width="600px" src="assets/ex7_2.png" alt="executing terraform plan with cloud foundry">

2. Apply the Terraform configuration to create the environment:

    ```bash
    terraform apply
    ```

    You will be prompted to confirm the creation of the environment. Type `yes` and press `Enter` to continue.
   The output should look like this:
    
    <img width="600px" src="assets/ex7_3.png" alt="executing terraform apply with cloud foundry provider">
    
    You can also check that everything is in place via the SAP BTP cockpit. You should see the Cloud Foundry environment in the subaccount:
    
     <img width="600px" src="assets/ex7_4.png" alt="SAP BTP Cockpit with Cloud Foundry environment">
## Summary

You've now successfully created a Cloud Foundry environment instance as well as a Cloud Foundry space in SAP BTP.

Continue to - [Exercise 5 - Create a CloudFoundry Space](../EXERCISE5/README.md).