provider "aws" {
  region = "eu-central-1"
  profile = "terraform"
}

# Account id
data "aws_caller_identity" "current" {}


module "vpc" {
  source                = "../../modules/vpc"

  project               = "selena"
  region                = var.region
  vpc_cidr              = "10.0.0.0/16"

  public_subnet_cidr    = "10.0.1.0/24"
  private_subnet_cidr   = "10.0.2.0/24"

  public_subnet_cidr_2  = "10.0.3.0/24"
  private_subnet_cidr_2 = "10.0.4.0/24"

  availability_zone     = var.availability_zone
  availability_zone_2   = var.availability_zone_2
}

module "users" {
  source = "./users"

  # variables
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region

  private_subnet_cidr_2       = var.private_subnet_cidr_2
  availability_zone_2         = var.availability_zone_2
  ami_id                      = data.aws_ami.selena_base.id
  key_name                    = var.key_name
  env                         = var.env
  alert_email                 = var.alert_email
  environment                 = var.environment
  default_security_group_id   = module.vpc.default_security_group_id

  route53_zone_id             = data.aws_route53_zone.main_zone.zone_id 

  # certificate_arn           = aws_acm_certificate_validation.users_service_cert_validation.certificate_arn

  public_subnet_1_id          = module.vpc.public_subnet_id
  public_subnet_2_id          = module.vpc.public_subnet_2_id
  vpc_id                      = module.vpc.vpc_id
  db_subnet_group             = module.vpc.db_subnet_group

  # Policies
  ec2_ecr_access_policy_arn  = module.shared_policies.ec2_ecr_access_policy_arn
}

module "hotels" {
  source                      = "./hotels"

  # variables
  account_id                  = data.aws_caller_identity.current.account_id
  region                      = var.region
  availability_zone           = var.availability_zone

  ami_id                      = data.aws_ami.selena_base.id
  key_name                    = var.key_name

  vpc_id                      = module.vpc.vpc_id
  public_subnet_1_id          = module.vpc.public_subnet_id
  public_subnet_2_id          = module.vpc.public_subnet_2_id
  private_subnet_1_id         = module.vpc.private_subnet_id

  route53_zone_id             = var.route53_zone_id
  environment                 = var.environment

  bastion_sg_id               = module.bastion.bastion_sg_id
  user_data_file              = "${path.root}/../../scripts/userdata/userdata_cockroach.sh"
  ssh_allowed_cidr            = "0.0.0.0/32"
  iam_instance_profile        = ""

  vpc_cidr                    = module.vpc.vpc_cidr
  my_ip_cidr                  = "0.0.0.0/32"

  # Policies
  ec2_ecr_access_policy_arn   = module.shared_policies.ec2_ecr_access_policy_arn
}

/*module "bookings" {
  source = "./bookings"

  route53_zone_id = var.route53_zone_id
  environment     = var.environment
}*/

module "bastion" {
  source           = "../../modules/bastion"

  project          = "selena"
  vpc_id           = module.vpc.vpc_id
  public_subnet_id = module.vpc.public_subnet_id

  ami_id           = data.aws_ami.selena_base.id
  key_name         = var.key_name
}
