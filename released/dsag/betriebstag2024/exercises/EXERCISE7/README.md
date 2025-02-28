# Exercise 7 - Setup a Cloud Foundry environment (optional)

## Goal of this Exercise 🎯

In this *optional* exercise you will earn how to create a Cloud Foundry environment instance and a Cloud Foundry space in SAP BTP using Terraform. You will see how to leverage multiple providers (the **real** strength of Terraform) and how to work with modules.

## Creation of a Cloud Foundry environment

We want to create a Cloud Foundry environment in the subaccount. We will not directly use the resources of the Terraform provider for SAP BTP, but leverage a concept called [modules](https://developer.hashicorp.com/terraform/language/modules).

Modules are a way to organize Terraform configurations into reusable components. We have a fitting module for the task at hand in this repository. Navigate to the `modules` folder in the root of this repo and you will find the fitting module at [environments/cloudfoundry/envinstance_cf](../../modules/environment/cloudfoundry/envinstance_cf/envinstance_cf.tf).

Inspect the folder and you will see a known file structure:

- `envinstance_cf_variables.tf`: The file contains the input variables for the module.
- `envinstance_cf.tf`: The file contains the main configuration of the module comprising the resource [`btp_subaccount_environment_instance`](https://registry.terraform.io/providers/SAP/btp/latest/docs/resources/subaccount_environment_instance) of the Terraform Provider for SAP BTP and the resource [`cloudfoundry_org_role`](https://registry.terraform.io/providers/cloudfoundry/cloudfoundry/latest/docs/resources/org_role) from the Terraform Provider for Cloud Foundry. It corresponds to the `main.tf` file of a Terraform configuration and also contains the required providers.
- `envinstance_cf_outputs.tf`: The file contains the output variables for the module.

When taking a closer look at the `envinstance_cf.tf` file, we see that we do not want to implement these steps again. We will re-use the module to create the Cloud Foundry environment.

### Step 1: Add the module to the Terraform configuration

First we need to add one more local variable in the `main.tf` file. Open the `main.tf` file and add the following code to the `locals` block:

```terraform
project_subaccount_cf_org = replace("${var.org_name}_${lower(var.project_name)}-${lower(var.stage)}", " ", "_")
```

Then add the following code to call this module:

```terraform
module "cloudfoundry_environment" {
  source = "../modules/environment/cloudfoundry/envinstance_cf"

  subaccount_id           = btp_subaccount.project.id
  instance_name           = local.project_subaccount_cf_org
  cf_org_name             = local.project_subaccount_cf_org
  plan_name               = "trial"
  cf_org_managers         = []
  cf_org_billing_managers = []
  cf_org_auditors         = []
}
```

As we are dealing with a local module we use the `source` attribute to point to the module. We pass the required input variables to the module. We do not assign any Cloud Foundry roles to additional users and provide empty lists for these parameters.

Save the changes.

### Step 2: Adjust the output variables

As we are using the output variables of the module, we need to adjust the output variables in the `outputs.tf` file. Open the `outputs.tf` file and add the following code:

```terraform
output "cloudfoundry_org_name" {
  value       = local.project_subaccount_cf_org
  description = "The name of the cloudfoundry org connected to the project account."
}

output "cloudfoundry_org_id" {
  value       = module.cloudfoundry_environment.cf_org_id
  description = "The ID of the cloudfoundry org connected to the project account."
}
```

We reference the output variables of the module via the `module` keyword. Save the changes.

### Step 4: Adjust the provider configuration

As we are using an additional provider we must make Terraform aware of this in the `provider.tf` file. Open the `provider.tf` file and add the following code to the `required_provider` block:

```terraform
cloudfoundry = {
      source  = "cloudfoundry/cloudfoundry"
      version = "1.1.0"
    }
```

To configure the Cloud Foundry provider add the following lines at the end of the file:

```terraform
provider "cloudfoundry" {
  api_url = "https://api.cf.${var.region}-001.hana.ondemand.com"
}
```

Save your changes.

> [!WARNING]
> We assume that the Cloud Foundry environment is deployed to the extension landscape 001. If this is not the case the authentication might fail. In a real-world scenario you would probably have a different boundary of content to the module.

To fulfill all requirements for the authentication against the Cloud Foundry environment you must export the following environment variables:

- Windows:

    ```pwsh
    $env:CF_USER=<your SAP BTP username>
    $env:CF_PASSWORD='<your SAP BTP password>'
    ```

- Linux/MacOS/GitHub Codespaces:

    ```bash
    export CF_USER=<your SAP BTP username>
    export CF_PASSWORD='<your SAP BTP password>'
    ```

> [!NOTE]
> Although we do not use the Cloud Foundry part of the module namely the assignment of users to the organization, Terraform will initialize the Cloud Foundry provider and try to authenticate against the Cloud Foundry environment. This is why we need to define the configuration and provide the credentials.

### Step 3: Apply the changes

As we have a new provider and a new module in place, we need to re-initialize the setup to download the required provider and module. Run the following command:

```bash
terraform init
```

The output should look like this:

<img width="600px" src="assets/ex7_1.png" alt="executing terraform init with cloud foundry provider">

> [!NOTE]
> There is also a command parameter called `--upgrade` for the `terraform init` command. This parameter will *upgrade* the provider to the latest version. As we are adding new providers, we do not need to use this parameter.

You know the drill by now:

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

The result should look like this:

<img width="600px" src="assets/ex7_3.png" alt="executing terraform apply with cloud foundry provider">

You can also check that everything is in place via the SAP BTP cockpit. You should see the Cloud Foundry environment in the subaccount:

 <img width="600px" src="assets/ex7_4.png" alt="SAP BTP Cockpit with Cloud Foundry environment">

## Creation of a Cloud Foundry space

As a last task we also want to add a Cloud Foundry space to the Cloud Foundry environment. We will use the same concept as before and leverage a module. Navigate to the `modules` folder in the root of this repo and you will find the fitting module at [environments/cloudfoundry/space_cf](../../modules/environment/cloudfoundry/space_cf/README.md).

### Step 1: Add the space name variable to the configuration

First we need to add one more variable in the `variables.tf` file. Open the `variables.tf` file and add the following code:

```terraform
variable "cf_space_name" {
  type        = string
  description = "The name of the Cloud Foundry space."
  default     = "dev"
}
```

This allows us to specify the name of the Cloud Foundry space. We also define a default value (`dev`) for the variable. Save the changes.

### Step 2: Add the module to the Terraform configuration

To trigger the creation of a Cloud Foundry space, we add the module to the `main.tf` file. Open the `main.tf` file and add the following code:

```terraform
module "cloudfoundry_space" {
  source = "../modules/environment/cloudfoundry/space_cf"

  cf_org_id           = module.cloudfoundry_environment.cf_org_id
  name                = var.cf_space_name
  cf_space_managers   = []
  cf_space_developers = []
  cf_space_auditors   = []
}
```

Save the changes.

### Step 3: Apply the changes

As we have all prerequisites already in place when it comes to provider configuration and authentication. However, we need to reinitialize the module that we use. To achieve that run the following command:

```bash
terraform init
```

The output should look like this:

<img width="600px" src="assets/ex7_5.png" alt="executing terraform init with cloud foundry provider">

Once we have initialized the module we can proceed with the creation of the Cloud Foundry space. As before we execute the following commands:

1. Plan the Terraform configuration to see what will be created:

    ```bash
    terraform plan
    ```

    The output should look like this:

    <img width="600px" src="assets/ex7_6.png" alt="executing terraform plan for cloud foundry space creation">

2. Apply the Terraform configuration to create the space:

    ```bash
    terraform apply
    ```

    You will be prompted to confirm the creation of the space. Type `yes` and press `Enter` to continue.

The result should look like this:

<img width="600px" src="assets/ex7_7.png" alt="executing terraform apply for cloud foundry space creation">

You can also check that everything is in place via the SAP BTP cockpit. You should see the Cloud Foundry space in the subaccount:

 <img width="600px" src="assets/ex7_8.png" alt="SAP BTP Cockpit with Cloud Foundry space">

## Summary

You've now successfully created a Cloud Foundry environment instance as well as a Cloud Foundry space in SAP BTP.

Continue to - [Exercise 8 - Cleanup](../EXERCISE8/README.md).
