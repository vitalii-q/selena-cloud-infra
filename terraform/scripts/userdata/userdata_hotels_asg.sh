#!/bin/bash
exec > /var/log/user-data.log 2>&1

echo "[INFO] UserData started"

DB_HOST="${db_host}"
export DB_HOST=$DB_HOST

yum update -y
yum install -y docker jq awscli

# Start Docker
systemctl start docker
systemctl enable docker

# Add ec2-user to docker group
usermod -aG docker ec2-user

mkdir -p /cockroach/certs

# Getting client certs for hotels-service from SSM
aws ssm get-parameter --name "/selena/cockroachdb/client.hotels_user.crt" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/client.hotels_user.crt
aws ssm get-parameter --name "/selena/cockroachdb/client.hotels_user.key" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/client.hotels_user.key
aws ssm get-parameter --name "/selena/cockroachdb/ca.crt" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/ca.crt

chmod 600 /cockroach/certs/client.hotels_user.key

# Login to ECR
aws ecr get-login-password --region eu-central-1 \
  | docker login --username AWS --password-stdin 235484063004.dkr.ecr.eu-central-1.amazonaws.com

# Fetch secrets from AWS Secrets Manager
SECRET_JSON=$(aws secretsmanager get-secret-value \
  --region eu-central-1 \
  --secret-id selena-hotels-db \
  --query SecretString \
  --output text)

export HOTELS_COCKROACH_USER=$(echo $SECRET_JSON | jq -r '.HOTELS_COCKROACH_USER')
export HOTELS_COCKROACH_PASSWORD=$(echo $SECRET_JSON | jq -r '.HOTELS_COCKROACH_PASSWORD')
export HOTELS_COCKROACH_DB_NAME=$(echo $SECRET_JSON | jq -r '.HOTELS_COCKROACH_DB_NAME')
export HOTELS_COCKROACH_HOST=$(echo $SECRET_JSON | jq -r '.HOTELS_COCKROACH_HOST')
export HOTELS_COCKROACH_PORT_INNER=$(echo $SECRET_JSON | jq -r '.HOTELS_COCKROACH_PORT_INNER')
export DB_SSLMODE=$(echo $SECRET_JSON | jq -r '.DB_SSLMODE')

# Non-sensitive env variables
export PROJECT_SUFFIX=prod
export LOCALHOST=localhost
export HOTELS_SERVICE_PORT=9064
export HOTELS_COCKROACH_PORT=9264

echo "[INFO] Pull hotels-service image from ECR"

# Pull image
docker pull 235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-hotels-service:amd64

echo "[INFO] Run hotels-service container"

# Run container
docker run -d \
  --name hotels-service \
  --network host \
  -v /cockroach/certs:/certs-cloud \
  -p $${HOTELS_SERVICE_PORT}:$${HOTELS_SERVICE_PORT} \
  -e PROJECT_SUFFIX \
  -e LOCALHOST \
  -e DB_SSLMODE \
  -e HOTELS_SERVICE_PORT \
  -e HOTELS_COCKROACH_USER \
  -e HOTELS_COCKROACH_PASSWORD \
  -e HOTELS_COCKROACH_DB_NAME \
  -e HOTELS_COCKROACH_HOST \
  -e HOTELS_COCKROACH_PORT \
  -e HOTELS_COCKROACH_PORT_INNER \
  235484063004.dkr.ecr.eu-central-1.amazonaws.com/selena-hotels-service:amd64

echo "[INFO] UserData finished"
