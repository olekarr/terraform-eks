# Terraform EKS

This repository contains Terraform configuration to provision an AWS Elastic Kubernetes Service (EKS) cluster along with associated resources such as VPC and node groups. It’s structured to support multiple environments (dev, qa, stage, prod) using variable files and modular components.

---

## 📁 Repository Structure

```
backend-dev.hcl
backend.tf
main.tf
manage_terraform.sh
output.tf
provider.tf
README.md
variables.tf
version.tf
env/
    dev.tfvars
    prod.tfvars
    qa.tfvars
    stage.tfvars
modules/
    eks/
        main.tf
        output.tf
        variables.tf
    nodegroups/
        main.tf
        output.tf
        variables.tf
    vpc/
        main.tf
        output.tf
        variables.tf
```

- **env/** – environment-specific variable files. Each `.tfvars` selects region, cluster name, etc.
- **modules/** – self-contained Terraform modules for `eks`, `nodegroups`, and `vpc`.
- **manage_terraform.sh** – helper script to initialize, plan, apply, destroy across environments.
- **backend*.tf / provider.tf / variables.tf / main.tf / output.tf / version.tf** – root configuration shared by all environments.

---

## ⚙️ Prerequisites

- [Terraform](https://www.terraform.io/) 1.5+ installed
- AWS CLI configured with appropriate credentials and permissions
- Bash shell (e.g., Git Bash on Windows) for running the helper script

---

## 🚀 Getting Started

1. **Choose an environment** (e.g. `dev`, `qa`, `stage`, `prod`).
2. Initialize Terraform (automatically handled by the script):

   ```bash
   ./manage_terraform.sh init dev
   ```

3. Preview changes:

   ```bash
   ./manage_terraform.sh plan dev
   ```

4. Apply configuration:

   ```bash
   ./manage_terraform.sh apply dev
   ```

5. Destroy resources when no longer needed:

   ```bash
   ./manage_terraform.sh destroy dev
   ```

> The script wraps `terraform` with appropriate `-var-file` arguments and backend configuration.

---

## 🧩 Modules Overview

- **vpc** – defines networking resources (VPC, subnets, route tables, etc.).
- **eks** – creates the EKS control plane and cluster resources.
- **nodegroups** – provisions managed node groups for worker nodes.

Each module exposes variables and outputs located in their respective `variables.tf` and `output.tf` files.

---

## 💡 Tips & Notes

- Backend configuration is stored in `backend.tf` and overrides for dev in `backend-dev.hcl`.
- Version constraints in `version.tf` ensure consistent Terraform releases.
- Update `.tfvars` files per environment to manage differences like instance types or node counts.

---

## 📝 License

Specify your license here (e.g., MIT).
