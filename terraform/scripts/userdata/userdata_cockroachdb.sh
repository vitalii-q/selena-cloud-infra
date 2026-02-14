#!/bin/bash
set -e

yum update -y
yum install -y docker jq
systemctl enable docker
systemctl start docker

mkdir -p /cockroach/certs

# get certs from SSM
aws ssm get-parameter --name "/selena/cockroachdb/ca.crt" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/ca.crt
aws ssm get-parameter --name "/selena/cockroachdb/node.crt" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/node.crt
aws ssm get-parameter --name "/selena/cockroachdb/node.key" --with-decryption --query "Parameter.Value" --output text > /cockroach/certs/node.key

docker run -d \
  --name cockroachdb \
  -p 26257:26257 \
  -p 8080:8080 \
  -v /var/lib/cockroach:/cockroach/cockroach-data \
  -v /cockroach/certs:/cockroach/certs \
  cockroachdb/cockroach:v23.2.4 \
  start-single-node \
  --certs-dir=/cockroach/certs \
  --listen-addr=0.0.0.0:26257 \
  --http-addr=0.0.0.0:8080
