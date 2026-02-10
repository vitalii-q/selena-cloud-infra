#!/bin/bash
set -e

yum update -y
yum install -y docker
systemctl enable docker
systemctl start docker

docker run -d \
  --name cockroachdb \
  --restart unless-stopped \
  -p 26257:26257 \
  -p 8080:8080 \
  -v /var/lib/cockroach:/cockroach/cockroach-data \
  cockroachdb/cockroach:v23.2.4 \
  start-single-node \
  --store=/cockroach/cockroach-data \
  --listen-addr=0.0.0.0:26257 \
  --http-addr=0.0.0.0:8080 \
  --insecure
