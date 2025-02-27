# SITBLR MARCH 2025 - Make BTP Account management a breeze with Terraform Exporter

In this Handson session you will discover how the BTP Terraform Exporter can swiftly bring any SAP BTP subaccount under terraform life cycle.Imagine managing your infrastructure entirely through declarative HCL by running terraform commands to handle the state changes.Now, picture doing that even when your subaccount is already running a Cloudfoundry runtime with active services.

With BTP Terraform Exporter, you can effortlessly import and manage those resources without writing a single line of code.

## Goal of this Exercise 🎯

In this hands-on exercise you will learn how to use the [BTP Terraform Exporter](https://sap.github.io/terraform-exporter-btp/) to make existing SAP Business Technology Platform resources into Terraform.

## Prerequisites

  - You need one SAP BTP Subaccount.
  - [Terraform CLI](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
  - [btptf CLI](https://sap.github.io/terraform-exporter-btp/install/)

## Exporting environment variables

The last step in the setup is the export of the environment variables that are required to authenticate against the Terraform provider for SAP BTP. For that export the following environment variables:

- Windows:

    ```pwsh
    $env:BTP_USERNAME=<your SAP BTP username>
    $env:BTP_PASSWORD='<your SAP BTP password>'
    $env:CF_USER=<your SAP BTP username>
    $env:CF_PASSWORD='<your SAP BTP password>'
    ```

- Linux/MacOS/GitHub Codespaces:

    ```bash
    export BTP_USERNAME=<your SAP BTP username>
    export BTP_PASSWORD='<your SAP BTP password>'
    export CF_USERNAME=<your SAP BTP username>
    export CF_PASSWORD='<your SAP BTP password>'
    ```

Validate that the values are set via:

- Windows: `$env:BTP_USERNAME` and `$env:BTP_PASSWORD`
- Linux/MacOS/GitHub Codeapses: `echo $BTP_USERNAME` and `echo $BTP_PASSWORD`


## Exercises 📚

In this HandsOn we want to make you familiar with the Terraform Provider and Terraform Exporter for SAP BTP. We will use the terraform provider to provision and manage resources in SAP BTP and Use Terraform Exporter to make an existing Subaccount resources under Terraform's management. To achieve this we will walk through the following steps:

1. [Exercise 1 - Setup of a Subaccount using BTP Terraform Provider](exercises/EXERCISE1/README.md)
1. [Exercise 2 - Export BTP Subaccount Using BTP Terraform Exporter ](exercises/EXERCISE2/README.md)