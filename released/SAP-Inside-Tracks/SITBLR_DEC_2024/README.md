# SITBLR DECEMBER 2024 - HandsOn SAP Terraform Provider for SAP BTP

## Goal of this HandsOn 🎯

In this HandsOn you will learn how to use the [Terraform Provider for SAP BTP](https://registry.terraform.io/providers/SAP/cp/latest/docs) to provision and manage resources in SAP BTP. The level of the exercises is beginner. You don't need any prior knowledge about Terraform or the Terraform Provider for SAP BTP. We will guide you through the exercises step by step.

## Prerequisites 📝

Make sure that the following prerequisites are met:

- You have an SAP BTP Trial Account. If you don't have one yet, you can get one [here](https://developers.sap.com/tutorials/hcp-create-trial-account.html).
- Make sure that your SAP Universal ID is configured correctly. You can find the instructions in [SAP Note 3085908](https://me.sap.com/notes/3085908).
- The Terraform provider does not support SSO or 2FA. Make sure that these options are not enforced for your account.


## Tools 🛠️

To execute the exercises you have the following options concerning the required tools installed:

In general you must clone this GitHub repository. You must have the Git client installed on your machine. You can find the installation instructions [here](https://git-scm.com/downloads).

You can then clone the repository via the following command:

```bash
git clone https://github.com/SAP-samples/btp-terraform-samples.git
```

you find the exercises in the folder `released/SAP-Inside-Tracks/SITBLR_DEC_2024/exercises`.


You can install the required tools locally on your machine. The following tools are required:

- [Terraform CLI](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- An editor of your choice. We recommend [Visual Studio Code](https://code.visualstudio.com/Download) with the [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).


## Exporting environment variables

The last step in the setup is the export of the environment variables that are required to authenticate against the Terraform provider for SAP BTP. Fo that export the following environment variables:

- Windows:

    ```pwsh
    $env:BTP_USERNAME=<your SAP BTP username>
    $env:BTP_PASSWORD='<your SAP BTP password>'
    ```

- Linux/MacOS/GitHub Codespaces:

    ```bash
    export BTP_USERNAME=<your SAP BTP username>
    export BTP_PASSWORD='<your SAP BTP password>'
    ```

Validate that the values are set via:

- Windows: `$env:BTP_USERNAME` and `$env:BTP_PASSWORD`
- Linux/MacOS/GitHub Codeapses: `echo $BTP_USERNAME` and `echo $BTP_PASSWORD`


## Summary

You've now prepared your development environment and have all information to finally start using Terraform provider for SAP BTP.  



## Exercises 📚

In this HandsOn we want to make you familiar with the Terraform Provider for SAP BTP. We will use the provider to provision and manage resources in SAP BTP. To achieve this we will walk through the following steps:

1. [Exercise 1 - Configure the Terraform Provider for SAP BTP](exercises/EXERCISE1/README.md)
1. [Exercise 2 - Setup of a subaccount](exercises/EXERCISE2/README.md)
1. [Exercise 3 - Assign entitlement,Subscription and its role assignments to a subaccount](exercises/EXERCISE3/README.md)
1. [Exercise 4 - Setup a Cloud Foundry environment and a space (optional)](exercises/EXERCISE4/README.md)
1. [Exercise 5 - Exercise 5 - Assignment of subaccount emergency administrators](exercises/EXERCISE5/README.md)
1. [Exercise 6 - Cleanup](exercises/EXERCISE6/README.md)



