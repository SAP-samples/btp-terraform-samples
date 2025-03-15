# Setup of integration Suite with OAutch Clients on SAP BTP Trial

## Setup Directory

In `01_base_setup_directory` we provide the basic setup for a directory that contains the integration-specific subaccounts. The directory can be managed or unmanaged.

## Setup Subaccount

In `02_base_setup_subaccount` we do a basic subaccount setup for the integration suite in a specifc stage like DEV or PROD. This comprises:

- Creation of the subaccount
- Assigning of the entitlement for the integration Suite application
- Creation of Cloud Foundry environment
- Creation of a Cloud Foundry space
- Several role collection assignments on subaccount, Cloud Foundry organization and Cloud Foundry space level


In this step the app gets published on the marketplace. In this case the application name is **not** the same as the service offering name that was entitled. Consequently it must be defined dynamically. As Terraform cannot calcuate a plan for this it cannot be subscribed to in the same step.

## Subscription to Integration Suite Application

in `03_base_setup_integration_app` we determine the application name dynamically and subscribe to the application. This subscription triggers the assignment of the role collection `Integration_Provisioner` to the subaccount. Consequently, this step also comprises the assignment of the role collection `Integration_Provisioner` to the users.

## Manual activation of capabilities

The activation of capabilities must be done via the subscribed application. After executing the activation several further role collections as well as service plans get created on global account as well as on subaccount level.

## Setup of OAuth Clients

After the manual activation of the capabilities, we want to create the OAuth clients with the service bindings. To achieve this several steps must be executed via Terraform as deined in `04_setup_oauth_clients`:

- Assignment of relevant service plans to the managed directory and to the subaccount
- Assignment of Integration Suite specific role collections to the users in the subaccount
- Creation of service instances for the OAuth clients in the Cloud Foundry space
- Creation of the service bindings for the OAuth clients in the Cloud Foundry space

Due to a setting of the services in the Cloud Foundry space, the service binding data cannot be fetched from the platform. To get the relevant data the user must naviagate to the cockpit namely the Cloud Foundry space and fetch the data from the service bindings in the UI.
