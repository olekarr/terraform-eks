#!/bin/bash

auto_approve=$1
action=$2
if [ -z "$env" ]; then
    echo "ERROR: Environment variable 'env' is not set."
    exit 1
fi

# Initialize Terraform
terraform init -backend-config=backend-$env.hcl


# Run Terraform plan
terraform plan -var-file=env/$env.tfvars

# Apply changes if auto-approve is set
if [ "$auto_approve" == "true" ]; then
    terraform $action -var-file=env/$env.tfvars --auto-approve
else
    terraform $action -var-file=env/$env.tfvars
fi
