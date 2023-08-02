# Setting up SAP Build Apps

To run this use case reliably, you run it in two steps.

## Step 1 - Prepare subaccount and SAP Build Apps

- Change to the folder `step1` and run the terraform script (`terraform init` and `terraform apply`).
- Note down the extracted output variables. These output variables are defined in the `outputs.tf` file.

## Step 2 - Execute Cloudfoundry related steps

- Change to the folder `step2` 
- Adapt the `terraform.tfvars` file and substitute the values for the variables `region`, `cf_api_endpoint`, `cf_org_id` `subaccount_cf_org` that you got from step1
- and run the terraform script (`terraform init` and `terraform apply`).
