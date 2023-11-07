# Terraform Workspace for Kyma GitOps

This Terraform workspace creates a BTP subaccount and a Kubernetes cluster with Kyma runtime, and then bootstraps it with [Flux CD](https://flux.io) for GitOps. 

## Structure

The workspace contains the following files:

- `main.tf`: Contains the resources and modules for creating the BTP subaccount, the Kyma runtime environment, and the Flux CD bootstrap.
- `outputs.tf`: Defines the output values for the Kyma dashboard URL and the Kubeconfig of the Kyma runtime.
- `provider.tf`: Specifies the required Terraform providers and their configurations.
- `variables.tf`: Defines the variables used across the workspace.

## Prerequisites

- You need admin access to a [BTP trial account](https://account.hanatrial.ondemand.com/trial/#/home/trial).
- You need to have [Terraform](https://developer.hashicorp.com/terraform/downloads) installed in your system.

## Usage

1. Create a new git repository to be used by flux  and fill it with the content you can find [here](https://github.com/SAP-samples/btp-terraform-samples/tree/kyma-gitops).

2. Clone the repository:
    ```
    git clone https://github.com/SAP-samples/btp-terraform-samples.git
    ```
3. Navigate to the directory:
    ```
    cd released/uc_kyma_gitops_fluxcd
    ```
4. Initialize Terraform:
    ```
    terraform init
    ```
5. Apply the Terraform configuration:
    ```
    terraform apply
    ```
The `terraform apply` command will prompt you for the values of the following variables:
- `globalaccount`: The subdomain of your trial account (e.g. `4605efebtrial-ga`)
- `fluxcd_git_repository`: The URL of the Git repository to bootstrap flux from.
- `fluxcd_git_username`: The username for basic authentication to the Git repository.
- `fluxcd_git_password`: The password for basic authentication to the Git repository (can be a personal access token).

## Outputs

The workspace provides the following outputs:

- `kyma_dashboard_url`: The URL of the Kyma dashboard.
- `kyma_kubeconfig`: The Kubeconfig of the Kyma runtime.

## Note

The Flux CD bootstrap configures the Kyma runtime to reconcile its state from the `fluxcd_git_branch` of the `fluxcd_git_repository`. The namespace `flux-system` is labeled with `istio-injection=enabled`, which enables Istio sidecar injection for the Flux CD components.
