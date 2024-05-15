# Backend as Kubernetes/Kyma

This Terraform backend configuration utilizes Kubernetes as a [backend](https://developer.hashicorp.com/terraform/language/settings/backends/kubernetes), storing the state in a Kubernetes secret. It also supports state locking, ensuring safe operations, by utilizing a Lease resource to manage locks.

Is is important to mention that by default Secrets in Kubernetes are **not** encrypted. For details, check the corresponding [Kubernetes documentation](https://kubernetes.io/docs/concepts/configuration/secret/).

> **Note**: For the CI/CD pipelines, it is recommended to use a service account's kubeconfig file to authenticate with Ky and bypass the need for interactive kubectl logins from the browser. This approach ensures a smoother and automated deployment process. Make sure that the user or service account running Terraform has the necessary permissions to read and write secrets in the namespace used to store the secret.

## Example Configuration

```terraform
terraform {
  backend "kubernetes" {
    secret_suffix    = "state"
    config_path      = "<path/to/your/kubeconfig>"
    namespace        = "<Namespace to store the secret>"
  }
}
```
