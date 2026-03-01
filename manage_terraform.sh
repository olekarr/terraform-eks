#!/usr/bin/env bash
set -euo pipefail

# Usage: ./manage_terraform.sh <env> <action> [auto_approve]
# Example: ./manage_terraform.sh dev apply true

ENV_NAME="${1:-}"
ACTION="${2:-}"
AUTO_APPROVE="${3:-false}"

if [[ -z "${ENV_NAME}" ]]; then
  echo "ERROR: env name is required (e.g., dev)."
  exit 1
fi

if [[ -z "${ACTION}" ]]; then
  echo "ERROR: action is required (plan|apply|destroy)."
  exit 1
fi

if [[ "${ACTION}" != "plan" && "${ACTION}" != "apply" && "${ACTION}" != "destroy" ]]; then
  echo "ERROR: Invalid action '${ACTION}'. Use plan, apply, or destroy."
  exit 1
fi

BACKEND_FILE="backend-${ENV_NAME}.hcl"
TFVARS_FILE="env/${ENV_NAME}.tfvars"

if [[ ! -f "${BACKEND_FILE}" ]]; then
  echo "ERROR: Backend config file not found: ${BACKEND_FILE}"
  exit 1
fi

if [[ ! -f "${TFVARS_FILE}" ]]; then
  echo "ERROR: tfvars file not found: ${TFVARS_FILE}"
  exit 1
fi

# Initialize Terraform with the selected backend config
terraform init -backend-config="${BACKEND_FILE}"

# Execute the requested action
if [[ "${ACTION}" == "plan" ]]; then
  terraform plan -var-file="${TFVARS_FILE}"
  exit 0
fi

if [[ "${AUTO_APPROVE}" == "true" ]]; then
  terraform "${ACTION}" -var-file="${TFVARS_FILE}" -auto-approve
else
  terraform "${ACTION}" -var-file="${TFVARS_FILE}"
fi