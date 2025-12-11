#!/bin/bash
set -e

# Install Docker on Amazon Linux 2023
sudo dnf install -y docker

# Enable Docker service
sudo systemctl enable docker
sudo systemctl start docker

# Add ec2-user to docker group
sudo usermod -aG docker ec2-user
