#!/bin/bash

# Script for making AMI image for microservices

# Run script from directory environments/dev: ../../packer/build.sh


set -e

# Go to the script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Get the first public subnet ID from Terraform output (from dev environment)
SUBNET_ID=$(terraform -chdir=../environments/dev output -json public_subnet_ids | jq -r '.[0]')
echo "Using SUBNET_ID: $SUBNET_ID"

# Initialize Packer
packer init templates/

# Validate the Packer template with the subnet variable
packer validate -var "subnet_id=$SUBNET_ID" templates/selena-base-ami.pkr.hcl

# Build the AMI with the subnet variable
packer build -var "subnet_id=$SUBNET_ID" templates/selena-base-ami.pkr.hcl

# Optional: display the latest AMI ID after build
LATEST_AMI=$(aws ec2 describe-images \
  --owners self \
  --filters "Name=name,Values=selena-base-ami-*" \
  --query "Images | sort_by(@, &CreationDate) | [-1].ImageId" \
  --output text \
  --region eu-central-1)

echo "Latest built AMI ID: $LATEST_AMI"
