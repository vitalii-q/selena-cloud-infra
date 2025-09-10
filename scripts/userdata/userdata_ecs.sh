#!/bin/bash

# Подключаемся к ECS Cluster
echo "ECS_CLUSTER=selena-users-cluster" >> /etc/ecs/ecs.config

# Установка Docker
amazon-linux-extras enable docker
dnf install -y docker
systemctl enable --now docker

# Установка ECS Agent
amazon-linux-extras enable ecs
dnf install -y amazon-ecs-init
systemctl enable --now ecs
