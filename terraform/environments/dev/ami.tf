# =========================================================
# AMI data for microservices: users-service, hotels-service
# =========================================================

# Dynamic AMI lookup for Selena Base AMI
data "aws_ami" "selena_base" {
  most_recent = true
  owners      = ["self"]

  filter {
    name   = "name"
    values = ["selena-base-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }
}
