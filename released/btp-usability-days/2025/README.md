# Sample for SAP BTP Usability Days 2025

This folder contains a sample setup of a subaccount on SAP BTP using the Terraform provider for SAP BTP.

> [!IMPORTANT]
> The sample is tested agianst a SAP BTP CPEA/BTPEA account. The configuration will not work when using a SAP BTP trial account.

## Prerequisites

Before you apply the configuration, make sure you have entered the necessary variables in the `samples.tfvars` file:

```terraform
globalaccount  = "<YOUR GLOBAL ACCOUNT SUBDOMAIN>"
cost_center    = "CC-12345678"
contact_person = "John Doe"
department     = "Sales"
```

If you use a custom platform IdP, make sure taht you also add the `idp` variable to the `samples.tfvars` file.

For the authentication to SAP BTP we recommend using the environment variables `BTP_USERNAME` and `BTP_PASSWORD` to store your credentials securely.

On Windows, you can set them in PowerShell like this:

```powershell
$env:BTP_USERNAME="your-username"
$env:BTP_PASSWORD="your-password"
```

On Linux or Mac OS, you can set them in the terminal like this:

```bash
export BTP_USERNAME="your-username"
export BTP_PASSWORD="your-password"
```

## Execution

To execute the configuration, run the following commands in your terminal:

1. Initialize the Terraform working directory:
   ```bash
   terraform init
   ```
2. Validate the configuration:
   ```bash
   terraform validate
   ```

3. Create and review the execution plan:
   ```bash
   terraform plan -var-file="samples.tfvars" -out="plan.out"
   ```

4. If the proposed changes are as expected, apply the execution plan:

   ```bash
   terraform apply "plan.out"
   ```

Once the apply is complete, you can find the outputs in the terminal or by running:

```bash
terraform output
```

The output `subaccount_url` provides a direct link to the created subaccount in the SAP BTP Cockpit.


## Cleanup

To remove the created resources and clean up your environment, run the following command:

```bash
terraform destroy -var-file="samples.tfvars"
```

Review the proposed plan and confirm the destruction of resources when prompted.


## Content

The configuration showcases some specific features:

- Validation of input variables using `validation` blocks in the `variables.tf` file.
- Implementing naming conventions
- Using maps and objects and the `lookup()` function to retrieve values based on the variables
- Using ternary operators for conditionally setting values resouce attributes
- Using modules as reusable components
- Creating multiple resources using `for_each` based on a list
- Creating outputs with dynamic values
