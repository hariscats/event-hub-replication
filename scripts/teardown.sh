#!/bin/bash

# Destroy Terraform-provisioned resources
echo "Destroying Terraform-provisioned resources..."
terraform destroy -auto-approve

echo "Teardown completed!"