# Setting up a sub account with the SAP AI Core service deployed

## Overview

1. Initialize your workspace:

   ```bash
   terraform init
   ```

4. You can check what Terraform plans to apply based on your configuration:

   ```bash
   terraform plan -var-file="step1.tfvars" -var-file="sample.tfvars" 
   ```

## In the end

You probably want to remove the assets after trying them out to avoid unnecessary costs. To do so execute the following command:

```bash
terraform destroy -var-file="step1.tfvars" -var-file="sample.tfvars" 
```
