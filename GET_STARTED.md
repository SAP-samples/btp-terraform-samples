
# Get started

To execute the samples in this repository, you need to have the Terraform CLI. You have three options to get up and running that are described in the following sections.

## Local installation

You can install the CLI locally on your machine as described in the installation instructions [here](https://learn.hashicorp.com/tutorials/terraform/install-cli). After that you can clone this repository and execute the samples locally.

> **Note**: There is a temporal limitation concerning the Terraform CLI version and the Terraform Provider for SAP BTP: the release `0.5.0-beta1` of the Terraform provider is working with version `1.5.7` (or lower) of the Terraform CLI. The release `0.6.0-beta2` and later of the Terraform provider is working with version `1.6.x` of the Terraform CLI. See also this [discussion](https://github.com/SAP/terraform-provider-btp/discussions/477). Please make sure to use the correct versions.

## Devcontainer

We provide a [devcontainer](https://code.visualstudio.com/docs/remote/containers) for Visual Studio Code which contains the Terraform CLI matching the latest release of the Terraform Provider for SAP BTP. There are two prerequisites to use the devcontainer:

- You need to have a local installation of [Docker](https://www.docker.com/) or any other OCI compatible runtime supported by your OS.
- You need to have [Visual Studio Code](https://code.visualstudio.com/) installed.
- You need to have the [Remote - Containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) extension installed in Visual Studio Code.

After that you can clone this repository and open it in Visual Studio Code. You can then open the command palette and select `Remote-Containers: Reopen in Container`. We provide two options for that:

- A *default* configuration that contains the Terraform CLI matching the latest release of the Terraform Provider for SAP BTP as well as the relevant VSCode extensions
- A *extended* configuration that injects the environment variables for the CLI (namely username and password values) from a `devcontainer.env` file located in the root of the `.devcontainer` folder. If you want to use this option, you need to create the file and add the following content:

    ```bash
    BTP_USERNAME=<PUT YOUR USERID HERE>
    BTP_PASSWORD=<PUT YOUR PASSWORD HERE>
    CF_USER=<PUT YOUR USERID HERE>
    CF_PASSWORD=<PUT YOUR PASSWORD HERE>
    ```

    This file will be stored locally and is excluded from git

This will build the devcontainer and open the repository in a container. You can then execute the samples in the container.

## GitHub Codespaces

You can also use GitHub Codespaces to execute the samples. You can find more details on how to use GitHub Codespaces [here](https://docs.github.com/en/codespaces/developing-in-codespaces/creating-a-codespace). Here you can only use the *default* configuration of the devcontainer as described above as the environment files are excluded from git and therefore not available in GitHub Codespaces.

You can also directly start the Codespace via this button:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://github.com/codespaces/new?hide_repo_select=true&ref=main&repo=656281656&machine=basicLinux32gb&devcontainer_path=.devcontainer%2Fdevcontainer.json&location=WestEurope)

> **Note**: There might be costs arising on your side when using GitHub Codespaces. For more details see the official documentation on [billing](https://docs.github.com/billing/managing-billing-for-github-codespaces/about-billing-for-github-codespaces) of GitHub Codespaces.
