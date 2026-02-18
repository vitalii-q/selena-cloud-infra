# Get the first public subnet in dev directory with command: terraform state show module.vpc.aws_subnet.public_subnet 
# example: id = "subnet-0cb581d0d0fd332c8"
#
# After that, you can run Packer in this directory:
# packer build -var "subnet_id=subnet-0cb581d0d0fd332c8" cockroachdb.pkr.hcl

packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">= 1.2.0"
    }
  }
}

variable "subnet_id" {
  type = string
}

source "amazon-ebs" "cockroachdb" {
  region = "eu-central-1"
  instance_type = "t3.nano"
  ssh_username = "ubuntu"
  ami_name = "selena-cockroachdb-{{timestamp}}"
  subnet_id = var.subnet_id
  associate_public_ip_address = true
  ssh_timeout = "2m"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners = ["099720109477"]    # Canonical Ubuntu official AMI 8GB
  }

  launch_block_device_mappings {
    device_name = "/dev/xvda"
    volume_size = 15
    volume_type = "gp3"
  }
}

build {
  sources = [
    "source.amazon-ebs.cockroachdb"
  ]
  provisioner "shell" {
    script = "../../scripts/packer/install_cockroachdb.sh"
  }
}
