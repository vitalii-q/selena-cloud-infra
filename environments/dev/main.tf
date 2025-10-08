provider "aws" {
  region = "eu-central-1"
  profile = "terraform"
}

module "users" {
  source = "./users"

  # variables
  private_subnet_cidr_2       = var.private_subnet_cidr_2
  availability_zone_2         = var.availability_zone_2
  ami_id                      = var.ami_id
  key_name                    = var.key_name
  instance_type               = var.instance_type
  env                         = var.env
  alert_email                 = var.alert_email

  users_service_ami_id        = var.ami_id
}
