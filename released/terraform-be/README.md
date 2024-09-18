# Terraform Remote Backend Configuration

In Terraform, a *backend* determines where the state data files are stored. This state data is crucial for tracking the resources managed by Terraform. There are different configuration options to define these backends. They are described in the [Terraform documentation](https://developer.hashicorp.com/terraform/language/backend).

The default configuration is the [local backend](https://developer.hashicorp.com/terraform/language/settings/backends/local) namely the local file system. However, this is not recommended for productive usage due to the lack of options to collaborate and securely store the state. Hence, it is common to use a remote backend.

## Available Backends

In general, Terraform supports a lot of generic and vendor-specific backends out of the box. You find an overview of the available backends in the [Terraform documentation](https://developer.hashicorp.com/terraform/language/settings#configuring-a-terraform-backend).

These built-in backends serve different purposes, from acting as remote disks for state files to supporting state locking, which helps prevent conflicts and ensures consistency during operations. It is important to note that you cannot load additional backends as plugins; only the listed built-in backends are available.

In the following section we will walk through different configurations.

### Local Backend

As mentioned the default backend stores state as a local file on disk. It is suitable for single-user environments e.g. when developing new configurations. You find more details in the [Terraform documentation](https://developer.hashicorp.com/terraform/language/settings/backends/local).

### Kubernetes Backend

The [Kubernetes backend](https://developer.hashicorp.com/terraform/language/settings/backends/kubernetes) stores state in a Kubernetes secret and supports state locking using a Lease resource. It allows for secure and collaborative state management in Kubernetes environments. You find a sample technical setup in the directory [k8sasbackend](./k8sasbackend/README.md)
