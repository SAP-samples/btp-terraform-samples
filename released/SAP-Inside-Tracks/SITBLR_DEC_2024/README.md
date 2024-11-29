# SITBLR DECEMBER 2024 - HandsOn SAP Terraform Provider for SAP BTP

## Goal of this HandsOn 🎯

In this HandsOn you will learn how to use the [Terraform Provider for SAP BTP](https://registry.terraform.io/providers/SAP/cp/latest/docs) to provision and manage resources in SAP BTP.

## Scenario 📚

In this HandsOn we want to make you familiar with the Terraform Provider for SAP BTP. We will use the provider to provision and manage resources in SAP BTP. To achieve this we will walk through the following steps:

1. [Exercise 1 - Configure the Terraform Provider for SAP BTP](exercises/EXERCISE1/README.md)
1. [Exercise 2 - Setup of a subaccount](exercises/EXERCISE2/README.md)
1. [Exercise 3 - Assign entitlement,Subscription and its role assignments to a subaccount](exercises/EXERCISE3/README.md)
1. [Exercise 4 - Setup a Cloud Foundry environment and a space (optional)](exercises/EXERCISE4/README.md)
1. [Exercise 5 - Exercise 5 - Assignment of subaccount emergency administrators](exercises/EXERCISE5/README.md)
1. [Exercise 6 - Cleanup](exercises/EXERCISE6/README.md)

The level of the exercises is beginner. You don't need any prior knowledge about Terraform or the Terraform Provider for SAP BTP. We will guide you through the exercises step by step.

## Prerequisites 📝

Make sure that the following prerequisites are met:

- You have an SAP BTP Trial Account. If you don't have one yet, you can get one [here](https://developers.sap.com/tutorials/hcp-create-trial-account.html).
- Make sure that your SAP Universal ID is configured correctly. You can find the instructions in [SAP Note 3085908](https://me.sap.com/notes/3085908).
- The Terraform provider does not support SSO or 2FA. Make sure that these options are not enforced for your account.

## Tools 🛠️

To execute the exercises you have the following options concerning the required tools installed:

- local installation
- usage of the provided dev container
- usage of GitHub Codespaces

You find details about the installation of the tools in the following sections

In general you must clone this GitHub repository. You must have the Git client installed on your machine. You can find the installation instructions [here](https://git-scm.com/downloads).

You can then clone the repository via the following command:

```bash
git clone https://github.com/SAP-samples/btp-terraform-samples.git
```

you find the exercises in the folder `released/dsag/betriebstag2024/exercises`.

### Local Installation

You can install the required tools locally on your machine. The following tools are required:

- [Terraform CLI](https://developer.hashicorp.com/terraform/install?product_intent=terraform)
- An editor of your choice. We recommend [Visual Studio Code](https://code.visualstudio.com/Download) with the [Terraform extension](https://marketplace.visualstudio.com/items?itemName=HashiCorp.terraform).

### Dev Container

As an alternative to the local installation you can use the provided dev container that contains all required tools. This requires that you have [Docker](https://www.docker.com/products/docker-desktop) installed on your machine. In addition you need the dev container extension for Visual Studio Code. You can find detailed instructions about the setup [here](https://code.visualstudio.com/docs/devcontainers/containers#_getting-started).

To start a dev container Docker must be running on your machine.

To use the dev container you must open the folder that contains the cloned repository in Visual Studio Code. You will be asked if you want to reopen the folder in the dev container. Confirm this.

If this is not the case execute the following steps:

1. Open the command palette in Visual Studio Code:

    - Windows / Linux: `Ctrl + Shift + P`
    - Mac: `Cmd + Shift + P`

2. Enter `Dev Containers: Reopen in Container` and confirm with `Enter`.

3. You will then be asked to select a dev container. Select the `Terraform provider for SAP BTP - Default` container:

    ![Select dev container](assets/devcontainer-selection.png)

The dev container will automatically start and you are ready to go

### GitHub Codespaces

To use [Codespaces](https://docs.github.com/codespaces/overview) you must have a GitHub account. If you don't have one so far, please [sign-up on GitHub](https://github.com/signup) before going through the exercises.

You can then access the Codespace following these steps:

1. Open the [GitHub repository of the Terraform samples](https://github.com/SAP-samples/btp-terraform-samples).

    ![Screenshot of GitHub repository Terraform samples](assets/repo-terraform-samples.png)

2. Click on this button and create the code space:

   [![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=656281656&skip_quickstart=true&machine=basicLinux32gb&geo=EuropeWest&devcontainer_path=.devcontainer%2Fdevcontainer.json)

    This will take a few minutes. Be patient 🙂

    ![Screenshot of navigation to Codespace creation in the repository Terraform samples](assets/codespace-creation.png)

3. While the Codespace is created for you, you will see this screen

    ![Screenshot of setup screen for Codespace](assets/codespace-setup-process.png)

4. Once all is done, you are in your Codespace.

    ![Screenshot of GitHub Codespace view on the repository Terraform samples](assets/codespace-screen.png)

> [!IMPORTANT]
> GitHub codespaces are free for a certain amount of time per month. For the hands-on session the free time is more than enough. **Don't forget to delete your codespace again after the hands-on session!**


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

## Folder layout

You find all exercises of this tutorial in the folder `released/dsag/betriebstag2024/exercises`. Each exercise is contained in a dedicated folder containing:

- A `README.md` file with the instructions for the exercise
- A folder `SOLUTION_EX<number>` which contains the solution for the exercise if needed including the file `terraform.tfvars-sample` contains the definition of the local variables. In case you get stuck you can check the content of this folder.  

In addition the folder `solution` contains the final configuration setup if you have gone through all exercises.

## Summary

You've now prepared your development environment and have all information to finally start using Terraform provider for SAP BTP.  

Continue to - [Exercise 1 - Configure the Terraform Provider for SAP BTP](exercises/EXERCISE1/README.md).
