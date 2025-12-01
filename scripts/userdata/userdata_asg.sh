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

# Fetch secrets from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value --secret-id selena-users-db-dev --query SecretString --output text)
export USERS_POSTGRES_DB_HOST=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_HOST')
export USERS_POSTGRES_DB_USER=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_USER')
export USERS_POSTGRES_DB_PASS=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_PASS')
export USERS_POSTGRES_DB_NAME=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_NAME')
export USERS_POSTGRES_DB_PORT_INNER=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_PORT_INNER')
export USERS_POSTGRES_DB_SSLMODE=$(echo $SECRET_JSON | jq -r '.USERS_POSTGRES_DB_SSLMODE')

# Non-sensitive env variables
export PROJECT_SUFFIX=prod
export LOCALHOST=localhost
export USERS_SERVICE_PORT=9065
export USERS_POSTGRES_DB_PORT=9265
export USERS_REDIS_PORT=9765
export HOTELS_SERVICE_URL=http://hotels-service:9064

# Pull latest image
docker pull 235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-users-service:latest

# Run container
docker run -d \
  --name users-service \
  --restart always \
  --network host \
  -p $USERS_SERVICE_PORT:$USERS_SERVICE_PORT \
  -e USERS_POSTGRES_DB_HOST \
  -e USERS_POSTGRES_DB_USER \
  -e USERS_POSTGRES_DB_PASS \
  -e USERS_POSTGRES_DB_NAME \
  -e USERS_POSTGRES_DB_PORT_INNER \
  -e USERS_POSTGRES_DB_SSLMODE \
  -e PROJECT_SUFFIX \
  -e LOCALHOST \
  -e USERS_SERVICE_PORT \
  -e USERS_POSTGRES_DB_PORT \
  -e USERS_REDIS_PORT \
  -e HOTELS_SERVICE_URL \
  235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-users-service:latest
