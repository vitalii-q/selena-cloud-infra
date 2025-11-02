#!/bin/bash

# Лог в файл для отладки
exec > /var/log/user-data.log 2>&1

# Обновление системы
yum update -y

# Установка PostgreSQL client
dnf update -y
dnf install -y postgresql15

# Установка Docker, git, nano, nc
amazon-linux-extras enable docker
yum install -y docker git nano nc
systemctl start docker
systemctl enable docker

# Добавить ec2-user в группу docker
usermod -aG docker ec2-user

cd /home/ec2-user

# Клонируем репозиторий, если не существует, иначе обновляем
if [ ! -d "selena-users-service" ]; then
    git clone https://github.com/vitalii-q/selena-users-service.git
    chown -R ec2-user:ec2-user selena-users-service
else
    cd selena-users-service
    sudo -u ec2-user git pull
    cd ..
fi

# Установка AWS CLI
yum install -y unzip curl
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

# Проверяем наличие .env в репозитории и скачиваем из S3 при отсутствии
if [ ! -f selena-users-service/users.env.cloud ]; then
    echo ".env (users.env.cloud) не найден, скачиваем из S3..."
    aws s3 cp s3://selena-users-service-env-dev/users.env.cloud selena-users-service/.env
    chown ec2-user:ec2-user selena-users-service/.env
else
    echo ".env (users.env.cloud) уже существует"
fi

chmod 600 selena-users-service/.env

cd selena-users-service

# Собираем docker-образ
sudo -u ec2-user docker build -t selena-users-service .

# Останавливаем старый контейнер, если он есть
if docker ps -a --format '{{.Names}}' | grep -q '^selena-users-service$'; then
    docker stop selena-users-service
    docker rm selena-users-service
fi

# Запускаем контейнер с использованием .env файла
sudo -u ec2-user docker run -d \
    --name selena-users-service \
    --env-file users.env.cloud \
    -p 9065:9065 \
    --restart always \
    selena-users-service:latest

# Установка CloudWatch Agent
cd /tmp
curl -O https://amazoncloudwatch-agent.s3.amazonaws.com/amazon_linux/amd64/latest/amazon-cloudwatch-agent.rpm
dnf install -y ./amazon-cloudwatch-agent.rpm

# Конфиг для CloudWatch Agent
cat <<CWA > /opt/aws/amazon-cloudwatch-agent/bin/config.json
{
    "agent": {
    "metrics_collection_interval": 60
    },
    "metrics": {
    "namespace": "UsersService",
    "metrics_collected": {
        "cpu": {
        "measurement": [
            {"name": "cpu_usage_idle", "rename": "CPUIdle", "unit": "Percent"},
            {"name": "cpu_usage_user", "rename": "CPUUser", "unit": "Percent"},
            {"name": "cpu_usage_system", "rename": "CPUSystem", "unit": "Percent"}
        ],
        "totalcpu": true
        }
    }
    }
}
CWA

# Запуск CloudWatch Agent
/opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
    -a fetch-config \
    -m ec2 \
    -c file:/opt/aws/amazon-cloudwatch-agent/bin/config.json \
    -s

systemctl status amazon-cloudwatch-agent --no-pager -l
