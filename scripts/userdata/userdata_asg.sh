#!/bin/bash
exec > /var/log/user-data.log 2>&1

# Start Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

# Login to ECR
aws ecr get-login-password --region eu-central-1 \
  | docker login --username AWS --password-stdin 235484063004.dkr.ecr.eu-central-1.amazonaws.com

# Pull latest image
docker pull 235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-users-service:latest

# Run container
docker run -d \
  --name users-service \
  --restart always \
  --network host \
  -p 9065:9065 \
  235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-users-service:latest
