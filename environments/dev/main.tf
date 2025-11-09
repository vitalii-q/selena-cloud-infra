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

  route53_zone_id             = module.users.users_service_route53_zone_id
  environment                 = var.environment

  users_alb_dns_name          = module.users.users_alb_dns_name
}

/*module "hotels" {
  source = "./hotels"

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}

module "bookings" {
  source = "./bookings"

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}*/