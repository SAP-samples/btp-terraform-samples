# Use case: Dynamically react to changing business events in your supply chain

This script is based on the [GitHub repository for the use case of Build Events-to-Business Actions Scenarios with SAP BTP and Microsoft Azure/AWS](https://github.com/SAP-samples/btp-events-to-business-actions-framework/tree/main). This is expected to work with SAP Cloud Connector and not for the Private Link. 

It uses the [Terraform provider for SAP BTP](https://registry.terraform.io/providers/SAP/btp/latest/docs) to setup the necessary BTP infrastructure for that use case.

Set environment variables for BTP, CF User Name and Password - "BTP_USERNAME", "BTP_PASSWORD", "CF_USER", "CF_PASSWORD" in terminal before executing terraform scripts
eg: export CF_USER="john.doe@test.com"    

