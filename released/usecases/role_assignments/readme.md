# BTP Role Collection Assignment

This Terraform configuration assigns role collections to users within an existing SAP BTP subaccount. The configuration does not create a new subaccount; it requires an existing subaccount ID to apply the assignments.

## Prerequisites

- Ensure you have the Subaccount Administrator role in the subaccount where you plan to assign role collections.

## Usage

### 1. Define Variables

Update the values of the following variables in your `terraform.tfvars` to match your setup:

- **`subaccount_id`**: The ID of the existing subaccount.
- **`role_collection_assignments`**: A map of role collections and the users assigned to each. Each entry includes:
  - `role_collection_name`: Name of the role collection.
  - `users`: A list of users to assign to this role collection.

### 2. Example Variable Values

Here's an example of `terraform.tfvars` with sample input values:

```hcl
subaccount_id = "your-existing-subaccount-id"

role_collection_assignments = [
  {
    role_collection_name = "Subaccount Service Administrator"
    users                = ["user1@example.com", "user2@example.com"] 
  },
  {
    role_collection_name = "Subaccount Viewer"
    users                = ["user1@example.com", "user2@example.com"]
  },
  {
    role_collection_name = "Destination Administrator"
    users                = [ "user1@example.com", "user2@example.com"]
  }
]
