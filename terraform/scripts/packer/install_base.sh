#!/bin/bash
set -e

# Update system
sudo yum update -y

# Install common tools
sudo yum install -y git unzip wget