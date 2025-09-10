#!/bin/bash
# Подключаемся к ECS Cluster
echo "ECS_CLUSTER=selena-users-cluster" >> /etc/ecs/ecs.config
amazon-linux-extras install -y docker
systemctl enable docker
systemctl start docker