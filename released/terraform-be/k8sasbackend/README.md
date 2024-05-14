# [Backend as Kubernetes/Kyma](https://developer.hashicorp.com/terraform/language/settings/backends/kubernetes)

This Terraform backend configuration utilizes Kubernetes as a remote backend, storing the state in a Kubernetes secret. It also supports state locking, ensuring safe operations, by utilizing a Lease resource to manage locks.

## Example Configuration

```hcl
terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "path/to/your/kubeconfig"
    namespace        = "<Namespace to store the secret>"
  }
}

Note: For the CI/CD pipelines, it's recommended to use a service account's kubeconfig file to authenticate with Kubernetes and bypass the need for interactive kubectl logins from the browser. This approach ensures a smoother and automated deployment process.
Make sure that the user or service account running Terraform has the necessary permissions to read and write secrets in the namespace used to store the secret.