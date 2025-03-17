# Setup of integration Suite with OAuth Clients on SAP BTP Trial

## Introduction

The Terrraform configurations in this folder provide a basic setup of on Integration Suite on an **SAP BTP Trial** account. The setup makes the following assumptions:

- You want to create a directory that contains all the subaccounts for the integration suite
- You want to create one or more subaccounts for the different stages (DEV, TEST, PROD) that use the integration Suite

The setup process comprises several steps that can be executed sequentially. Due to the design of the provisioning process this setup cannot be executed in one step. The steps follow into two buckets:

- Basic setup *before* the activation of the capabilities of the Integration Suite
- Setup *after* the activation of the capabilities of the Integration Suite

We describe the steps in the following sections.

> [!IMPORTANT]
> If you want to doa deployment on a productive account, you must exchange all trial specific settings and variable validations.


## Steps before the activation of the capabilities

### Setup Directory

In `01_base_setup_directory` we provide the basic setup for a directory that contains the integration-specific subaccounts. The directory can be managed or unmanaged.

> [!NOTE]
> This step can be omitted if you do not want to have a directory that contains the subaccounts for the integration suite.

### Setup Subaccount

In `02_base_setup_subaccount` we do a basic subaccount setup for the integration suite in a specific stage like DEV or PROD. This comprises:

- Creation of the subaccount
- Assigning of the entitlement for the integration Suite application
- Creation of Cloud Foundry environment
- Creation of a Cloud Foundry space
- Several role collection assignments on subaccount, Cloud Foundry organization and Cloud Foundry space level

In this step the app gets published on the marketplace. In this case the application name is **not** the same as the service offering name that was entitled. Consequently, it must be defined dynamically. As Terraform cannot calculate a plan for this it cannot be subscribed to in the same step.

> [!NOTE]
> If you omitted the creation of the directory in the previous step, you must leave the `parent_id` empty in the `variables.tf` file.

### Subscription to Integration Suite Application

in `03_base_setup_integration_app` we determine the application name dynamically and subscribe to the application. This subscription triggers the assignment of the role collection `Integration_Provisioner` to the subaccount. Consequently, this step also comprises the assignment of the role collection `Integration_Provisioner` to the users.

## Manual activation of capabilities

The activation of capabilities must be done via the subscribed application. After executing the activation several further role collections as well as service plans get created on global account as well as on subaccount level.

## Steps after the activation of the capabilities

### Setup of OAuth Clients

After the manual activation of the capabilities, we want to create the OAuth clients with the service bindings. To achieve this several steps must be executed via Terraform as defined in `04_setup_oauth_clients`:

- Assignment of relevant service plans to the managed directory and to the subaccount
- Assignment of Integration Suite specific role collections to the users in the subaccount
- Creation of service instances for the OAuth clients in the Cloud Foundry space
- Creation of the service bindings for the OAuth clients in the Cloud Foundry space

Due to a setting of the services in the Cloud Foundry space, the service binding data cannot be fetched from the platform. To get the relevant data the user must navigate to the cockpit namely the Cloud Foundry space and fetch the data from the service bindings in the UI.

## Variables

Each step requires some variables to be set as defined in the `variables.tf` file. To give you an idea about the content of the variables we provide a `terraform.tfvars.sample` file in each step.
