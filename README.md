# Terraform EKS Infrastructure

This repository provisions an Amazon EKS cluster on AWS using Terraform.  
It includes networking (VPC), the EKS control plane, and managed node groups.

The project is modular and supports multiple environments such as `dev`, `qa`, `stage`, and `prod`.

---

## 📁 Project Structure

```

backend-dev.hcl
backend.tf
main.tf
manage_terraform.sh
output.tf
provider.tf
variables.tf
version.tf
README.md

env/
dev.tfvars
qa.tfvars
stage.tfvars
prod.tfvars

modules/
vpc/
main.tf
variables.tf
output.tf

eks/
main.tf
variables.tf
output.tf

nodegroups/
main.tf
variables.tf
output.tf

````

---

## 🏗 Architecture Overview

This project follows a layered design:

- **VPC Module** – Creates networking components such as VPC, subnets, route tables, and NAT (if enabled).
- **EKS Module** – Provisions the EKS control plane and OIDC provider (IRSA-ready).
- **Nodegroups Module** – Creates managed worker nodes attached to the cluster.
- **Root Module** – Wires everything together using environment-specific configurations.

---

## ⚙️ Prerequisites

Before using this repository, ensure the following:

- Terraform 1.5+
- AWS CLI configured with appropriate credentials
- IAM permissions to create VPC, IAM, and EKS resources
- Bash shell (Linux/macOS or Git Bash on Windows)

---

## 🌍 Environment Configuration

Each environment uses:

- A backend configuration file (`backend-<env>.hcl`)
- A variable file (`env/<env>.tfvars`)

This ensures:

- Separate state per environment
- Independent configuration values
- Safe multi-environment deployments

---

## 🚀 Usage

### Plan Infrastructure

```bash
./manage_terraform.sh dev plan
````

### Apply Infrastructure

```bash
./manage_terraform.sh dev apply
```

With auto-approve:

```bash
./manage_terraform.sh dev apply true
```

### Destroy Infrastructure

```bash
./manage_terraform.sh dev destroy
```

The script automatically:

* Initializes Terraform with the correct backend
* Selects the appropriate `.tfvars` file
* Executes the requested Terraform action

---

## 🗂 State Management

* Remote state is stored in S3.
* State locking is handled using DynamoDB.
* Backend configuration is environment-specific.

This setup prevents concurrent state conflicts and supports team usage.

---

## 📝 Design Notes

* Nodes are deployed to private subnets when NAT is enabled.
* If NAT is disabled, nodes fall back to public subnets.
* OIDC provider is created to support IAM Roles for Service Accounts (IRSA).
* Common tags are consistently applied across all resources.

---



