# Получаем первый public subnet через terraform output -json и jq
# echo $SUBNET_ID
# SUBNET_ID=$(terraform -chdir=environments/dev output -json public_subnet_ids | jq -r '.[0]')
#
# После этого можно запускать Packer:
# packer build -var "subnet_id=$SUBNET_ID" packer/templates/selena-base-ami.pkr.hcl

packer {
  required_version = ">= 1.8.0"
  required_plugins {
    amazon = {
      version = ">= 1.5.0"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

variable "subnet_id" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "selena_base" {
  region                  = "eu-central-1"
  instance_type           = "t3.nano"         # <- temporary build instance
  ssh_username            = "ec2-user"

  # Get the latest Amazon Linux 2023
  source_ami_filter {
    filters = {
      name                = "al2023-ami-*"
      architecture        = "x86_64"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }
    owners      = ["137112412989"] # AWS official owner ID
    most_recent = true
  }

  ami_name                = "selena-base-ami-${local.timestamp}"
  ami_description         = "Base AMI for Selena project (Docker, Git, CloudWatch, system updates)"
  associate_public_ip_address = true

  subnet_id               = var.subnet_id
  
  tags = {
    Project = "Selena"
    Env     = "dev"
    Type    = "BaseAMI"
  }
}

build {
  name    = "selena-base-ami"
  sources = ["source.amazon-ebs.selena_base"]

  provisioner "shell" {
    script = "./scripts/packer/install_base.sh"
  }

  provisioner "shell" {
    script = "./scripts/packer/install_docker.sh"
  }

  provisioner "shell" {
    script = "./scripts/packer/install_cloudwatch_agent.sh"
  }
}
