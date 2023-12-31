#!/bin/bash

# Initialize Terraform
echo "Initializing Terraform..."
terraform init

# Apply Terraform configuration
echo "Applying Terraform configuration..."
terraform apply -auto-approve

# Output any Terraform outputs
echo "Printing outputs..."
terraform output

echo "Setup completed!"