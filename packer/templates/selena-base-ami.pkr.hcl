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

variable "region" {
  type    = string
  default = "eu-central-1"
}

variable "source_ami" {
  type    = string
  default = "ami-0cff079720c1be186"
}

variable "subnet_id" {
  type = string
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "selena_base" {
  region                  = var.region
  instance_type           = "t3.micro"
  source_ami              = var.source_ami
  ssh_username            = "ec2-user"
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
