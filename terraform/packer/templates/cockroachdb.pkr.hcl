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

  iam_instance_profile = "packer-ssm-role-instance-profile"

  source_ami_filter {
    filters = {
      name                = "ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"
      root-device-type    = "ebs"
      virtualization-type = "hvm"
    }

    most_recent = true
    owners = ["099720109477"]    # Canonical Ubuntu official AMI 8GB
  }

  # Override the root block device of the base Ubuntu AMI.
  # The original Ubuntu AMI already contains a root disk (/dev/sda1).
  # Without this override, adding another mapping could create an additional EBS volume.
  # This block ensures the AMI has exactly one root disk with the defined configuration.
  launch_block_device_mappings { 
    device_name           = "/dev/sda1"
    volume_size           = 8
    volume_type = "gp3"
    delete_on_termination = true 
  }
}

build {
  sources = [
    "source.amazon-ebs.cockroachdb"
  ]

  # --- Create certs directory ---
  provisioner "shell" {
    inline = [
      "mkdir -p /tmp/certs"
    ]
  }

  # --- Copy CockroachDB certificates to temporary EC2 instance ---
  provisioner "file" {
    source      = "../../../../hotels-service/secure/certs-cloud/ca.crt"
    destination = "/tmp/certs/ca.crt"    # temporary directory in EC2
  }

  provisioner "file" {
    source      = "../../../../hotels-service/secure/certs-cloud/node.crt"
    destination = "/tmp/certs/node.crt"
  }

  provisioner "file" {
    source      = "../../../../hotels-service/secure/certs-cloud/node.key"
    destination = "/tmp/certs/node.key"
  }

  # --- Install CockroachDB and configure system ---

  provisioner "shell" {
    script = "../../scripts/packer/install_cockroachdb.sh"
  }
}